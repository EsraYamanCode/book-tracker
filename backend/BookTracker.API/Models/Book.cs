using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace BookTracker.API.Models;

public enum BookStatus
{
    NotStarted,  // Okunmadı
    Reading,     // Okunuyor
    Completed    // Tamamlandı
}

public class Book
{
    [Key]
    public int Id { get; set; }

    [Required]
    [MaxLength(200)]
    public string Title { get; set; } = string.Empty;

    [Required]
    [MaxLength(150)]
    public string Author { get; set; } = string.Empty;

    // Tasarımdaki mürdüm, zeytin yeşili vb. kapak hex renkleri için
    public string CoverColorHex { get; set; } = "#723348";

    public BookStatus Status { get; set; } = BookStatus.Reading;

    // Saniye cinsinden toplam süre
    public int TotalReadingSeconds { get; set; } = 0;

    public DateTime CreatedAt { get; set; } = DateTime.UtcNow;

    [ForeignKey("User")]
    public int UserId { get; set; }
    public User? User { get; set; }

    public ICollection<ReadingSession> Sessions { get; set; } = new List<ReadingSession>();
}