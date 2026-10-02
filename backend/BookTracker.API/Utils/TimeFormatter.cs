namespace BookTracker.API.Utils;

public static class TimeFormatter {
    public static string FormatSeconds(int totalSeconds) {
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
}