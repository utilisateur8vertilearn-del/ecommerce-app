# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What this is

A .NET 10 / ASP.NET Core e-commerce sample built as microservices and orchestrated by **.NET Aspire**. Data lives in EF Core **in-memory** databases (no external DB, no Docker). The README is in French and is the authoritative user-facing guide.

## Commands

Run from the repository root (the folder containing `ECommerce.slnx`).

```bash
# Run everything — this is the only command you normally need.
# Starts all services + the Aspire dashboard. Watch the terminal for the
# "Login URL" (contains ?t=<token>); the port changes on every launch.
dotnet run --project src/ECommerce.AppHost

# Build / restore the whole solution
dotnet build

# One-time on a fresh machine: trust the HTTPS dev cert, or the Aspire
# dashboard fails with UntrustedRoot errors.
dotnet dev-certs https --trust
```

Stop everything with `Ctrl+C` in the AppHost terminal.

> There is **no test project** in this solution. Do not invent `dotnet test` workflows; verify changes by running the AppHost and exercising the web UI or the gateway routes.

Each service exposes its OpenAPI document at `/openapi/v1.json` in Development.

## Architecture

Six projects (see `ECommerce.slnx`). The dependency/start order is declared in `src/ECommerce.AppHost/AppHost.cs`:

```
Web (Blazor) → Gateway (YARP) → Catalog.Api
                              ↘  Ordering.Api → Catalog.Api
```

- **ECommerce.AppHost** — the orchestrator; the project you launch. `AppHost.cs` declares each service, its `WithReference`/`WaitFor` dependencies, and the resource names used for service discovery.
- **ECommerce.Web** — Blazor Server frontend (`Components/Pages/`). Calls services *through the gateway* via typed `HttpClient`s in `Services/`.
- **ECommerce.Gateway** — YARP reverse proxy. Routing rules live in `appsettings.json` (`ReverseProxy` section): `/catalog/{**}` and `/ordering/{**}` strip their prefix and forward to the named cluster.
- **ECommerce.Catalog.Api** — products service. Minimal-API endpoints + in-memory EF Core.
- **ECommerce.Ordering.Api** — orders service. On `POST /api/orders` it validates each product by calling the Catalog service synchronously over HTTP (`Services/CatalogServiceClient.cs`).
- **ECommerce.ServiceDefaults** — shared `AddServiceDefaults()` / `MapDefaultEndpoints()` extensions: OpenTelemetry, `/health` + `/alive` checks (Development only), standard resilience handlers, and service discovery. Referenced by every runnable service.

### Key conventions

- **No hard-coded service URLs.** Inter-service base addresses use the Aspire scheme `https+http://<resource-name>` (e.g. `https+http://catalog`, `https+http://gateway`), resolved at runtime by service discovery. The `<resource-name>` must match the string passed to `AddProject<>(...)` in `AppHost.cs`. Web targets `gateway`; Ordering targets `catalog` directly.
- **Endpoints** are minimal APIs grouped in `Endpoints/*.cs` via a `MapXxxEndpoints` extension on `IEndpointRouteBuilder`, wired up in each service's `Program.cs`. Request/response shapes are `record` DTOs co-located in the same file.
- **Persistence** is `UseInMemoryDatabase` with `db.Database.EnsureCreated()` at startup. Catalog seeds demo products in `Data/CatalogDbContext.cs` (`OnModelCreating` → `HasData`). **All data resets on every restart.**
- New service projects must call `builder.AddServiceDefaults()` and `app.MapDefaultEndpoints()`, and reference `ECommerce.ServiceDefaults`.

## Repo automation (`.claude/`)

- A **PreToolUse hook** (`.claude/hooks/secret-scan.sh`) runs before every Bash call and **blocks `git commit`** if a likely secret appears in the staged diff. If a commit is blocked, remove the secret (use env vars / a vault) rather than working around the hook.
- Project skills (French) under `.claude/skills/`: `git-commit` (Conventional Commits, always confirms before committing), `open-pr` (push + `gh pr create`, refuses to commit on `main`/`master`), `init-repo`. Follow Conventional Commits for messages here.
