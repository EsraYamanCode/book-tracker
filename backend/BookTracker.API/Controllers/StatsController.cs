using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using BookTracker.API.Data;

namespace BookTracker.API.Controllers;

[Authorize]
[ApiController]
[Route("api/[controller]")]
public class StatsController : BaseApiController
{
    private readonly AppDbContext _context;

    public StatsController(AppDbContext context)
    {
        _context = context;
    }

    [HttpGet("summary")]
    public async Task<IActionResult> GetSummary()
    {
        var userId = GetCurrentUserId();

        // 1. Kullanıcının tüm seanslarını Book üzerinden çekiyoruz
        var sessions = await _context.ReadingSessions
            .Include(s => s.Book)
            .Where(s => s.Book != null && s.Book.UserId == userId)
            .ToListAsync();

        // 2. Takvim için: Gün bazında toplam okunan dakikalar (Örn: "2026-10-17": 35)
        var activityMap = sessions
            .GroupBy(s => s.CreatedAt.Date)
            .ToDictionary(
                g => g.Key.ToString("yyyy-MM-dd"),
                g => g.Sum(s => s.DurationSeconds) / 60
            );

        // 3. Güncel Seri (Streak) Hesabı
        var sessionDates = activityMap.Keys
            .Select(d => DateTime.Parse(d).Date)
            .OrderByDescending(d => d)
            .ToHashSet();

        int streak = 0;
        var checkDate = DateTime.UtcNow.Date;

        // Bugün henüz okuma yapılmadıysa dünden itibaren seriye bak
        if (!sessionDates.Contains(checkDate))
        {
            checkDate = checkDate.AddDays(-1);
        }

        // Geriye doğru ardışık günleri say
        while (sessionDates.Contains(checkDate))
        {
            streak++;
            checkDate = checkDate.AddDays(-1);
        }

        return Ok(new
        {
            currentStreak = streak,
            activityMap = activityMap
        });
    }
}