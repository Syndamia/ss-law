# S.S. Law

This is a lightweight system/template for creating your own static website.

You create webpages in Markdown, in (your fork of) the repository (which you'll have to commit and push if you're using GitHub or GitLab as a host).
Afterwards they're converted and "stapled" together with [ssg](https://romanzolotarev.com/ssg.html) and [lowdown](https://kristaps.bsd.lv/lowdown/), then more advanced editing is done on them with [AWK scripts](#awk) and finally everything is automatically "deployed".
All of those operations are done by a couple of shell scripts.

It is based upon the setup for [my website](https://syndamia.com), so if you want to see a more advanced generation configuration, with some already created AWK scripts, [click here](https://gitlab.com/Syndamia/syndamiadotcom).

The goal of this template is to be as simple, understandable and expandable as possible.
You're **highly encouraged** to figure out what everything does and to modify it according to your needs.
Everything that comes out of the box is just default configurations, remove what you don't need and replace what you don't like.

## Contents

1. [How it all works and what are files for](#how-it-all-works-and-what-are-files-for)
   1. [Scripts](#scripts)
   2. [AWK](#awk)
2. [How to use](#how-to-use)
   1. [Configuring generate-site](#configuring-generate-site)
3. [Background](#background)

## How it all works and what are files for

The main tools that power everything are ssg, lowdown and awk.
Essentially, ssg takes all of your website files, where

- Markdown pages are converted into `.html` files via lowdown, and then ssg inserts `_header.html` and `_footer.html` at the top and bottom of every such `.html` file
- and all other files are taken as-is,

and puts everything in a nice folder (`public`).
Afterwards, all AWK scripts are combined (which improves efficiency) into one and are ran on all `.html` files inside that folder.

### Scripts

Inside the `generate-scripts` folder you'll find the shell scripts, which automate the creation of your website.
The `get-` scripts download and "install" ssg and lowdown, while `generate-site.sh` does the actual site generation.

`.gitlab-ci.yml` and `.github/workflows/github-ci.yml` are your pipeline configurations.
With them GitLab and GitHub (respectively) can generate your site automatically, with their servers, and host it for you too.
`deploy.sh` is a manual script which can be used to generate your site without GitHub or GitLab.
All three use the stuff in `generate-scripts`.
I'm encouraging you to remove the ones that you know you won't need.

`.ssgignore` has files and folder which will not be used for site generation.

### AWK

As mentioned, the preferred way to do special formatting to your generated (`html`) pages is via AWK scripts, because it's decently simple and very powerful.
An AWK script goes through the file, line by line, and then matches text patterns, which can then be processed any way you want (including modifying the current line).

An example use case would be to add your own syntax, lets say you want to type `&&gb` in Markdown, and in the HTML page that should be replaced with some HTML code, containing the image of the British flag.
Or alternatively, what if you want to automatically insert an image next to every occurrence of a word, without having to specify it in the Markdown file.

Good resources for the language are

- [The AWK programming language](https://archive.org/details/pdfy-MgN0H1joIoDVoIC7)
- [Awk -- A Pattern Scanning and Processing Language](https://www.researchgate.net/publication/2425273_Awk_---_A_Pattern_Scanning_and_Processing_Language_Second_Edition)

However, there are some caveats with the AWK scripts, in the context of this template:

- If every script printed the current line, you would get duplicated lines, so that is handled by `generate-site.sh`.
  *Note:* If you don't want to print a line, do `$0 = 0`.
- For this reason, files in `awk-scripts` are managed by their first character:
  
  + If it is `#`, then that script is a "library", just a collection of custom AWK functions
  + If it is a capital latter, the script is ran before the line is printed
  + If it is a lowercase letter, the script is ran after the line is printed

  Do remember that any ordering between scripts with the same starting character isn't guaranteed!

- Running every script individually is inefficient, for every file, every script would have to open and close it, usually taking up about 100ms, which can stack up if you have a lot of content.
  Additionally, you can't share data from a pre-print script to a post-print script.
  That is why all scripts are combined into one big script, in which first are the "libraries", then the pre-print, the printing line and finally the post-print.
  This means that:

  + global variable names must be unique between all scripts
  + `exit` cannot be used, instead have some sort of check in the "pattern" part of your rules (that need `exit`)

## How to use

There are 3 provided ways to (easily) generate it, using pipelines and scripts:

- GitLab:
  1. Fork the repository
  2. Make sure `Pages` under `Settings/General/Visibility, project features, permissions/Pages` and `CI/CD` under `Settings/General/Visibility, project features, permissions/Repository` are enabled.
  3. Run the pipeline (needed only for the first time): go to `CI/CD / Pipelines` and press the `Run pipeline` from the top right corner, then on the new window press `Run pipeline` (no need to input anything).

  - After that, the pipeline will be ran automatically.
    You can view your website link and change domain in `Deployments/Pages`

- GitHub:
  1. Fork the [GitHub mirror](https://github.com/Syndamia/ss-law)
  2. Create a `gh-pages` branch in your fork: on the top left, next to "branch", press on `main`, then enter `gh-pages` and press below `Create branch: gh-pages`
  3. Inside `Settings/Code and automation/Pages`, you'll need to select for `Source`, `Deploy from a branch` and for `Branch` select `gh-pages` and `/(root)`.
  4. Enable actions: go to `Actions`, then press `I understand my workflows, go ahead and enable them`
  5. Run the workflow (needed only for the first time): in the `Actions` page, to the left, press `Website on GitHub pages`, then in the blue rectangle, to the left, press `Run workflow`, and then again `Run workflow` in the pop-up

  - After that, the workflow will be ran automatically.
    You can view your website link and change domain in `Settings/Code and automation/Pages`.

- Server/locally (manually):
  1. Fork the repository (either from GitLab or GitHub, whichever you prefer)
     + This step can be skipped, if you intend to edit the website directly where it is hosted.
  2. Clone it
  3. Run the `deploy.sh` script
  
  - The website will be available inside the `public` folder.
    You can directly just view and open the generated `.html` files, but it's better to use an HTTP server.

### Configuring generate-site

There are a couple of variables which control how your website will be generated:

- `SOURCE_FOLDER`: The directory where the pages for your website are located (relative to the repository).
  By default it's `.`, meaning exactly where all other repo files are.
- `AWK_FOLDER`: Location of your awk scripts (relative to the repository).
- `SSG_TITLE`: The title that will be included in all of your pages
- `SSG_BASE_URL`: The base URL (`https://website.com`) of your website

Depending on how you generate the website, those variables will be available/have to be modified either in:

- `.github/workflows/github-ci.yml` (if using GitHub)
- `.gitlab-ci.yml` (if using GitLab)
- `deploy.sh` (if generating manually)

## Background

This template is pretty much my [website](https://gitlab.com/Syndamia/syndamiadotcom) generation stack, extracted as a standalone template, with some pipelines and nice default configurations.
However, I was introduced to ssg and lowdown from [Wolfgang's Channel](https://www.youtube.com/channel/UCsnGwSIHyoYN0kiINAGUKxg) on YouTube, and more specifically, from his [tutorial](https://www.youtube.com/watch?v=N_ttw2Dihn8).

The name is a word-play on the main three technologies used: **SS**g, **L**owdown, **aw**k
