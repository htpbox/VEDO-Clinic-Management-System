using MediCore.Application.Common;
using System.Net;
using System.Text.Json;

namespace MediCore.API.Middleware;

public class GlobalExceptionMiddleware
{
    private readonly RequestDelegate _next;
    private readonly ILogger<GlobalExceptionMiddleware> _logger;

    public GlobalExceptionMiddleware(
        RequestDelegate next,
        ILogger<GlobalExceptionMiddleware> logger)
    {
        _next = next;
        _logger = logger;
    }

    public async Task InvokeAsync(HttpContext context)
    {
        try
        {
            await _next(context);
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Unhandled exception: {Message}", ex.Message);
            await HandleExceptionAsync(context, ex);
        }
    }

    private static async Task HandleExceptionAsync(HttpContext context, Exception exception)
    {
        context.Response.ContentType = "application/json";

        var response = exception switch
        {
            UnauthorizedAccessException => new
            {
                StatusCode = HttpStatusCode.Unauthorized,
                ApiResult = ApiResponse<object>.Fail("€Ì— „’—Õ »«·Ê’Ê·")
            },
            KeyNotFoundException => new
            {
                StatusCode = HttpStatusCode.NotFound,
                ApiResult = ApiResponse<object>.Fail("«·⁄‰’— «·„ÿ·Ê» €Ì— „ÊÃÊœ")
            },
            _ => new
            {
                StatusCode = HttpStatusCode.InternalServerError,
                ApiResult = ApiResponse<object>.Fail("ÕœÀ Œÿ√ œ«Œ·Ì ›Ì «·Œ«œ„")
            }
        };

        context.Response.StatusCode = (int)response.StatusCode;

        var json = JsonSerializer.Serialize(response.ApiResult, new JsonSerializerOptions
        {
            PropertyNamingPolicy = JsonNamingPolicy.CamelCase
        });

        await context.Response.WriteAsync(json);
    }
}
