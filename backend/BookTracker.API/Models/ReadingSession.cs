using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace BookTracker.API.Models;

public class ReadingSession
{
    [Key]
    public int Id { get; set; }

    [ForeignKey("Book")]
    public int BookId { get; set; }
    public Book? Book { get; set; }

    public DateTime StartTime { get; set; }
    public DateTime EndTime { get; set; }

    // Oturumda geçen süre (saniye)
    public int DurationSeconds { get; set; }

    public DateTime CreatedAt { get; set; } = DateTime.UtcNow;
}