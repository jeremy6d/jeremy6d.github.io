# GitHub Pages Deployment – Transition Plan

This document outlines how to move jeremyweiland.com from its current hosting to **GitHub Pages**, with builds and deploys handled by **GitHub Actions**.

---

## Current state

- **Stack:** Hugo static site, `hugo-split-theme`, `config.toml` with `baseURL = "https://www.jeremyweiland.com/"`
- **Deployment:** None automated in this repo (no existing CI/CD)
- **Theme:** `themes/hugo-split-theme` is in-repo (not a Git submodule)

---

## Target state

- **Hosting:** GitHub Pages (Actions build + deploy)
- **URL:** Keep **https://www.jeremyweiland.com/** via custom domain
- **Flow:** Push to `main` → Action builds Hugo → deploys to GitHub Pages

---

## Prerequisites

1. **GitHub account** and (if needed) a repo for this site.
2. **Repo choice** (pick one):
   - **Option A – User/org site:** Repo named `USERNAME.github.io` (e.g. `jeremyweiland.github.io` or `jeremy6d.github.io`).  
     Site will be at `https://USERNAME.github.io` until you add a custom domain.
   - **Option B – Project site:** Repo named e.g. `jeremyweiland.com` or `jeremyweiland-site`.  
     Site will be at `https://USERNAME.github.io/REPO_NAME/` until you add a custom domain.
3. **Custom domain:** You’ll point `www.jeremyweiland.com` (and optionally `jeremyweiland.com`) at GitHub Pages (see below).

---

## Step-by-step transition

### 1. Create or use a GitHub repository

- If you don’t have a repo yet: [Create a new repository](https://github.com/new).
- If you use **Option A**, name it exactly `USERNAME.github.io` (replace `USERNAME` with your GitHub username).
- Initialize and push this project (e.g. from your existing `jeremyweiland.com` folder):

  ```bash
  cd /path/to/jeremyweiland.com
  git init
  git add .
  git commit -m "Initial commit: Hugo site for GitHub Pages"
  git branch -M main
  git remote add origin https://github.com/USERNAME/REPO_NAME.git
  git push -u origin main
  ```

- Replace `USERNAME` and `REPO_NAME` with your actual GitHub username and repo name.

### 2. Enable GitHub Pages (Source: GitHub Actions)

- In the repo: **Settings → Pages**.
- Under **Build and deployment**, set **Source** to **GitHub Actions**.
- No need to create a `gh-pages` branch; the workflow deploys via the Pages artifact.

### 3. Add the workflow and config change (already in this repo)

This repo now includes:

- **`.github/workflows/hugo.yaml`** – Builds Hugo and deploys to GitHub Pages on push to `main` (and on manual run).
- **`config.toml`** – Optional `[caches]` for the image cache so builds are cache-friendly (see Hugo’s [cacheDir](https://gohugo.io/configuration/all/#cachedir)).

If you haven’t committed them yet:

```bash
git add .github/workflows/hugo.yaml config.toml
git commit -m "Add GitHub Actions workflow and cache config for GitHub Pages"
git push origin main
```

### 4. Confirm the first deploy

- Open the repo on GitHub → **Actions**.
- You should see a run for the push (or a manual “Build and deploy” run).
- When it’s green, open the URL shown in the **deploy** step (e.g. `https://USERNAME.github.io` or `https://USERNAME.github.io/REPO_NAME/`).

### 5. Configure custom domain (www.jeremyweiland.com)

- Repo **Settings → Pages**.
- Under **Custom domain**, enter: `www.jeremyweiland.com`.
- Save. GitHub will show DNS instructions and optionally create a **CNAME** file in the deployed site (the workflow deploys `public/`; GitHub Pages can add CNAME for you when you set the custom domain in Settings).
- At your DNS provider (where jeremyweiland.com is managed):
  - Add a **CNAME** for `www` → `USERNAME.github.io` (or the exact target GitHub shows), **or**
  - Use GitHub’s recommended **A** records if you prefer.
- Wait for DNS and GitHub’s certificate (can take minutes to an hour). Enforce HTTPS once GitHub reports the certificate as ready.

### 6. (Optional) Redirect root domain to www

- If you want `jeremyweiland.com` → `https://www.jeremyweiland.com`:
  - At your DNS provider, add an **ALIAS** or **ANAME** (or CNAME where supported) for the apex `jeremyweiland.com` to the same target as `www`, **or**
  - Use a redirect service (e.g. your registrar’s redirect) from `jeremyweiland.com` to `https://www.jeremyweiland.com`.

---

## After transition

- **Edits:** Edit content (e.g. `content/resume.md`) and/or config, commit and push to `main`. The workflow will build and deploy automatically.
- **Local preview:** Run `hugo server` before pushing.
- **baseURL:** Already set to `https://www.jeremyweiland.com/` in `config.toml`; the workflow overrides `baseURL` in CI to the Pages URL so both default and custom domain work.

---

## Rollback

- To stop using GitHub Pages: in **Settings → Pages**, set Source to “None” or delete the repo.
- To revert to a previous host: point DNS back to the old host and (if needed) restore content there.

---

## Summary checklist

- [ ] Create or choose GitHub repo (e.g. `USERNAME.github.io` or `jeremyweiland.com`).
- [ ] Push this Hugo site to `main`.
- [ ] Set Pages source to **GitHub Actions**.
- [ ] Commit and push `.github/workflows/hugo.yaml` and any `config.toml` cache changes.
- [ ] Verify first deploy in the Actions tab.
- [ ] Set custom domain `www.jeremyweiland.com` in Pages settings and DNS.
- [ ] (Optional) Set up apex redirect `jeremyweiland.com` → `https://www.jeremyweiland.com`.

Once these are done, the site is fully transitioned to GitHub Pages with automated deploys on every push to `main`.
