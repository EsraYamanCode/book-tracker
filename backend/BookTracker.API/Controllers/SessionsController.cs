using System.Security.Claims;
using BookTracker.API.Data;
using BookTracker.API.DTOs;
using BookTracker.API.Models;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using BookTracker.API.Utils;

namespace BookTracker.API.Controllers;

[Authorize]
[ApiController]
[Route("api/[controller]")]
public class SessionsController : BaseApiController
{
    private readonly AppDbContext _context;

    public SessionsController(AppDbContext context)
    {
        _context = context;
    }


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
                FormattedDuration = TimeFormatter.FormatSeconds(s.DurationSeconds),
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
            FormattedTotalTime = TimeFormatter.FormatSeconds(book.TotalReadingSeconds),
            CreatedAt = book.CreatedAt,
            SessionCount = sessions.Count,
            Sessions = sessions
        });
    }

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
            formattedTotal = TimeFormatter.FormatSeconds(book.TotalReadingSeconds)
        });
    }

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