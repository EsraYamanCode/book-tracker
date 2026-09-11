using System.Security.Claims;
using BookTracker.API.Data;
using BookTracker.API.DTOs;
using BookTracker.API.Models;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;

namespace BookTracker.API.Controllers;

[Authorize] // Token zorunlu kılındı
[ApiController]
[Route("api/[controller]")]
public class BooksController : ControllerBase
{
    private readonly AppDbContext _context;

    public BooksController(AppDbContext context)
    {
        _context = context;
    }

    // Token içindeki kullanıcı ID'sini çeken yardımcı metod
    private int GetCurrentUserId()
    {
        var idClaim = User.FindFirst(ClaimTypes.NameIdentifier)?.Value;
        return int.TryParse(idClaim, out var userId) ? userId : 0;
    }

    // Toplam saniyeyi "1 sa 28 dk" veya "45 dk" şeklinde formatlayan metod
    private static string FormatSeconds(int totalSeconds)
    {
        if (totalSeconds == 0) return "—";

        var timeSpan = TimeSpan.FromSeconds(totalSeconds);
        var hours = (int)timeSpan.TotalHours;
        var minutes = timeSpan.Minutes;

        if (hours > 0 && minutes > 0)
            return $"{hours} sa {minutes} dk";
        if (hours > 0)
            return $"{hours} sa";
        if (minutes > 0)
            return $"{minutes} dk";

        return $"{totalSeconds} sn";
    }

    [HttpGet]
    public async Task<ActionResult<IEnumerable<BookResponseDto>>> GetMyBooks()
    {
        var userId = GetCurrentUserId();

        var books = await _context.Books
            .Where(b => b.UserId == userId)
            .OrderByDescending(b => b.CreatedAt)
            .Select(b => new BookResponseDto
            {
                Id = b.Id,
                Title = b.Title,
                Author = b.Author,
                CoverColorHex = b.CoverColorHex,
                Status = b.Status.ToString(),
                TotalReadingSeconds = b.TotalReadingSeconds,
                FormattedTotalTime = FormatSeconds(b.TotalReadingSeconds),
                CreatedAt = b.CreatedAt
            })
            .ToListAsync();

        return Ok(books);
    }

    [HttpGet("{id}")]
    public async Task<ActionResult<BookResponseDto>> GetBook(int id)
    {
        var userId = GetCurrentUserId();

        var book = await _context.Books
            .FirstOrDefaultAsync(b => b.Id == id && b.UserId == userId);

        if (book == null)
            return NotFound(new { message = "Kitap bulunamadı." });

        return Ok(new BookResponseDto
        {
            Id = book.Id,
            Title = book.Title,
            Author = book.Author,
            CoverColorHex = book.CoverColorHex,
            Status = book.Status.ToString(),
            TotalReadingSeconds = book.TotalReadingSeconds,
            FormattedTotalTime = FormatSeconds(book.TotalReadingSeconds),
            CreatedAt = book.CreatedAt
        });
    }

    [HttpPost]
    public async Task<ActionResult<BookResponseDto>> CreateBook([FromBody] CreateBookDto dto)
    {
        var userId = GetCurrentUserId();

        var book = new Book
        {
            Title = dto.Title.Trim(),
            Author = dto.Author.Trim(),
            CoverColorHex = string.IsNullOrWhiteSpace(dto.CoverColorHex) ? "#723348" : dto.CoverColorHex,
            Status = BookStatus.NotStarted, // Yeni eklenen kitap varsayılan "Okunmadı"
            UserId = userId,
            TotalReadingSeconds = 0,
            CreatedAt = DateTime.UtcNow
        };

        _context.Books.Add(book);
        await _context.SaveChangesAsync();

        return CreatedAtAction(nameof(GetBook), new { id = book.Id }, new BookResponseDto
        {
            Id = book.Id,
            Title = book.Title,
            Author = book.Author,
            CoverColorHex = book.CoverColorHex,
            Status = book.Status.ToString(),
            TotalReadingSeconds = book.TotalReadingSeconds,
            FormattedTotalTime = FormatSeconds(book.TotalReadingSeconds),
            CreatedAt = book.CreatedAt
        });
    }

    [HttpDelete("{id}")]
    public async Task<IActionResult> DeleteBook(int id)
    {
        var userId = GetCurrentUserId();

        var book = await _context.Books
            .FirstOrDefaultAsync(b => b.Id == id && b.UserId == userId);

        if (book == null)
            return NotFound(new { message = "Silinecek kitap bulunamadı." });

        _context.Books.Remove(book);
        await _context.SaveChangesAsync();

        return Ok(new { message = "Kitap başarıyla silindi." });
    }
}