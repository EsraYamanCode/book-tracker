using System.IdentityModel.Tokens.Jwt;
using System.Security.Claims;
using System.Text;
using BookTracker.API.Data;
using BookTracker.API.DTOs;
using BookTracker.API.Models;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using Microsoft.IdentityModel.Tokens;
using Microsoft.AspNetCore.Authorization;
using Google.Apis.Auth;

namespace BookTracker.API.Controllers;

[ApiController]
[Route("api/[controller]")]
public class AuthController : BaseApiController
{
    private readonly AppDbContext _context;
    private readonly IConfiguration _config;

    public AuthController(AppDbContext context, IConfiguration config)
    {
        _context = context;
        _config = config;
    }

    [HttpPost("register")]
    public async Task<IActionResult> Register([FromBody] RegisterDto dto)
    {
        if (await _context.Users.AnyAsync(u => u.Email == dto.Email.ToLower()))
        {
            return BadRequest(new { message = "Bu e-posta adresi zaten kayıtlı." });
        }

        // Şifreyi BCrypt ile güvenli hash'e çeviriyoruz
        string passwordHash = BCrypt.Net.BCrypt.HashPassword(dto.Password);

        var user = new User
        {
            Email = dto.Email.ToLower(),
            PasswordHash = passwordHash
        };

        _context.Users.Add(user);
        await _context.SaveChangesAsync();

        var token = GenerateJwtToken(user);

        return Ok(new AuthResponseDto
        {
            UserId = user.Id,
            Email = user.Email,
            Token = token
        });
    }

    [HttpPost("login")]
    public async Task<IActionResult> Login([FromBody] LoginDto dto)
    {
        var user = await _context.Users.FirstOrDefaultAsync(u => u.Email == dto.Email.ToLower());

        if (user == null || !BCrypt.Net.BCrypt.Verify(dto.Password, user.PasswordHash))
        {
            return Unauthorized(new { message = "Geçersiz e-posta veya şifre." });
        }

        var token = GenerateJwtToken(user);

        return Ok(new AuthResponseDto
        {
            UserId = user.Id,
            Email = user.Email,
            Token = token
        });
    }
    [HttpPost("google")]
    public async Task<IActionResult> GoogleLogin([FromBody] GoogleLoginDto dto)
    {
        try
        {
            // 1. Google'dan gelen ID Token'ı Google sunucularında doğruluyoruz
            var payload = await GoogleJsonWebSignature.ValidateAsync(dto.IdToken);

            if (payload == null)
            {
                return BadRequest(new { message = "Geçersiz Google token'ı." });
            }

            var email = payload.Email.ToLower();

            // 2. Kullanıcı veritabanımızda var mı kontrol ediyoruz
            var user = await _context.Users.FirstOrDefaultAsync(u => u.Email == email);

            // 3. Kullanıcı yoksa otomatik oluşturuyoruz
            if (user == null)
            {
                user = new User
                {
                    Email = email,
                    PasswordHash = BCrypt.Net.BCrypt.HashPassword(Guid.NewGuid().ToString()) // Rastgele şifre hash'i
                };

                _context.Users.Add(user);
                await _context.SaveChangesAsync();
            }

            // 4. Kendi uygulamamıza ait JWT token'ı üretiyoruz
            var token = GenerateJwtToken(user);

            return Ok(new AuthResponseDto
            {
                UserId = user.Id,
                Email = user.Email,
                Token = token
            });
        }
        catch (InvalidJwtException)
        {
            return Unauthorized(new { message = "Google doğrulaması başarısız oldu." });
        }
        catch (Exception ex)
        {
            return StatusCode(500, new { message = $"Sunucu hatası: {ex.Message}" });
        }
    }

    private string GenerateJwtToken(User user)
    {
        var claims = new[]
        {
            new Claim(ClaimTypes.NameIdentifier, user.Id.ToString()),
            new Claim(ClaimTypes.Email, user.Email)
        };

        var key = new SymmetricSecurityKey(Encoding.UTF8.GetBytes(_config["Jwt:Key"]!));
        var creds = new SigningCredentials(key, SecurityAlgorithms.HmacSha256);

        var token = new JwtSecurityToken(
            issuer: _config["Jwt:Issuer"],
            audience: _config["Jwt:Audience"],
            claims: claims,
            expires: DateTime.UtcNow.AddDays(7), // 7 gün geçerli token
            signingCredentials: creds
        );

        return new JwtSecurityTokenHandler().WriteToken(token);
    }

    [Authorize]
    [HttpDelete("account")]
    public async Task<IActionResult> DeleteAccount()
    {
        var userId = GetCurrentUserId();

        var user = await _context.Users
            .Include(u => u.Books)
            .FirstOrDefaultAsync(u => u.Id == userId);

        if (user == null)
            return NotFound(new { message = "Kullanıcı bulunamadı." });

        _context.Users.Remove(user);
        await _context.SaveChangesAsync();

        return Ok(new { message = "Hesap başarıyla silindi." });
    }
}