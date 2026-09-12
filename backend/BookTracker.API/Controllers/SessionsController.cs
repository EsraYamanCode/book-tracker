using System.Security.Claims;
using BookTracker.API.Data;
using BookTracker.API.DTOs;
using BookTracker.API.Models;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;

namespace BookTracker.API.Controllers;

[Authorize]
[ApiController]
[Route("api/[controller]")]
public class SessionsController : ControllerBase
{
    private readonly AppDbContext _context;

    public SessionsController(AppDbContext context)
    {
        _context = context;
    }

    private int GetCurrentUserId()
    {
        var idClaim = User.FindFirst(ClaimTypes.NameIdentifier)?.Value;
        return int.TryParse(idClaim, out var userId) ? userId : 0;
    }

    private static string FormatSeconds(int totalSeconds)
    {
        if (totalSeconds == 0) return "0 dk";
        var timeSpan = TimeSpan.FromSeconds(totalSeconds);
        var hours = (int)timeSpan.TotalHours;
        var minutes = timeSpan.Minutes;

        if (hours > 0 && minutes > 0) return $"{hours} sa {minutes} dk";
        if (hours > 0) return $"{hours} sa";
        if (minutes > 0) return $"{minutes} dk";
        return $"{totalSeconds} sn";
    }

    // Bir kitabın detaylarını ve geçmiş oturumlarını getirir
    [HttpGet("book/{bookId}")]
    public async Task<ActionResult<BookDetailResponseDto>> GetBookSessions(int bookId)
    {
        var userId = GetCurrentUserId();

        var book = await _context.Books
            .Include(b => b.Sessions)
            .FirstOrDefaultAsync(b => b.Id == bookId && b.UserId == userId);

        if (book == null)
            return NotFound(new { message = "Kitap bulunamadı." });

        var sessions = book.Sessions
            .OrderByDescending(s => s.CreatedAt)
            .Select(s => new SessionResponseDto
            {
                Id = s.Id,
                DurationSeconds = s.DurationSeconds,
                FormattedDuration = FormatSeconds(s.DurationSeconds),
                CreatedAt = s.CreatedAt
            })
            .ToList();

        return Ok(new BookDetailResponseDto
        {
            Id = book.Id,
            Title = book.Title,
            Author = book.Author,
            CoverColorHex = book.CoverColorHex,
            Status = book.Status.ToString(),
            TotalReadingSeconds = book.TotalReadingSeconds,
            FormattedTotalTime = FormatSeconds(book.TotalReadingSeconds),
            CreatedAt = book.CreatedAt,
            SessionCount = sessions.Count,
            Sessions = sessions
        });
    }

    // Oturum kaydı ekler (Duraklatıldığında çağrılır)
    [HttpPost("book/{bookId}/log")]
    public async Task<IActionResult> LogSession(int bookId, [FromBody] LogSessionDto dto)
    {
        var userId = GetCurrentUserId();

        var book = await _context.Books
            .FirstOrDefaultAsync(b => b.Id == bookId && b.UserId == userId);

        if (book == null)
            return NotFound(new { message = "Kitap bulunamadı." });

        if (dto.DurationSeconds <= 0)
            return BadRequest(new { message = "Geçerli bir okuma süresi girilmelidir." });

        var session = new ReadingSession
        {
            BookId = bookId,
            StartTime = dto.StartTime,
            EndTime = dto.EndTime,
            DurationSeconds = dto.DurationSeconds,
            CreatedAt = DateTime.UtcNow
        };

        // Kitabın toplam süresini artır ve durumunu 'Okunuyor' yap
        book.TotalReadingSeconds += dto.DurationSeconds;
        if (book.Status == BookStatus.NotStarted)
        {
            book.Status = BookStatus.Reading;
        }

        _context.ReadingSessions.Add(session);
        await _context.SaveChangesAsync();

        return Ok(new
        {
            message = "Oturum başarıyla kaydedildi.",
            newTotalSeconds = book.TotalReadingSeconds,
            formattedTotal = FormatSeconds(book.TotalReadingSeconds)
        });
    }

    // Kitabı Bitir butonu için
    [HttpPost("book/{bookId}/complete")]
    public async Task<IActionResult> CompleteBook(int bookId)
    {
        var userId = GetCurrentUserId();

        var book = await _context.Books
            .FirstOrDefaultAsync(b => b.Id == bookId && b.UserId == userId);

        if (book == null)
            return NotFound(new { message = "Kitap bulunamadı." });

        book.Status = BookStatus.Completed;
        await _context.SaveChangesAsync();

        return Ok(new { message = "Tebrikler! Kitap tamamlandı olarak işaretlendi." });
    }
}