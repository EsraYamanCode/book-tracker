using Microsoft.EntityFrameworkCore;
using BookTracker.API.Models;

namespace BookTracker.API.Data;

public class AppDbContext : DbContext
{
    public AppDbContext(DbContextOptions<AppDbContext> options) : base(options) { }

    public DbSet<User> Users => Set<User>();
    public DbSet<Book> Books => Set<Book>();
    public DbSet<ReadingSession> ReadingSessions => Set<ReadingSession>();

    protected override void OnModelCreating(ModelBuilder modelBuilder)
    {
        base.OnModelCreating(modelBuilder);

        // Kullanıcı silinirse ona bağlı kitaplar da silinsin (Cascade)
        modelBuilder.Entity<Book>()
            .HasOne(b => b.User)
            .WithMany(u => u.Books)
            .HasForeignKey(b => b.UserId)
            .OnDelete(DeleteBehavior.Cascade);

        // Kitap silinirse ona bağlı seans kayıtları da silinsin
        modelBuilder.Entity<ReadingSession>()
            .HasOne(s => s.Book)
            .WithMany(b => b.Sessions)
            .HasForeignKey(s => s.BookId)
            .OnDelete(DeleteBehavior.Cascade);
    }
}