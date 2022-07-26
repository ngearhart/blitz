using Microsoft.AspNetCore.SignalR;

namespace blitz.Hubs
{
    public class DefaultHub : Hub
    {
        public async Task Hello()
        {
            await Clients.All.SendAsync("Hello");
        }
    }
}
