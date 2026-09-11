using System.ComponentModel.DataAnnotations;
using BookTracker.API.Models;

namespace BookTracker.API.DTOs;

public class CreateBookDto
{
    [Required(ErrorMessage = "Kitap adı zorunludur.")]
    [MaxLength(200)]
    public string Title { get; set; } = string.Empty;

    [Required(ErrorMessage = "Yazar adı zorunludur.")]
    [MaxLength(150)]
    public string Author { get; set; } = string.Empty;

    // Tasarımdaki renk paleti için varsayılan renk mürdüm
    public string CoverColorHex { get; set; } = "#723348";
}

public class BookResponseDto
{
    public int Id { get; set; }
    public string Title { get; set; } = string.Empty;
    public string Author { get; set; } = string.Empty;
    public string CoverColorHex { get; set; } = "#723348";
    public string Status { get; set; } = string.Empty;
    public int TotalReadingSeconds { get; set; }
    public string FormattedTotalTime { get; set; } = string.Empty;
    public DateTime CreatedAt { get; set; }
}