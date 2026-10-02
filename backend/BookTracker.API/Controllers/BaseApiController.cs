using System.Security.Claims;
using Microsoft.AspNetCore.Mvc;

namespace BookTracker.API.Controllers;

public abstract class BaseApiController : ControllerBase {
    protected int GetCurrentUserId () {
        var idClaim = User.FindFirst(ClaimTypes.NameIdentifier)?.Value;
        return int.TryParse(idClaim, out var userId) ? userId : 0;
    }
}
