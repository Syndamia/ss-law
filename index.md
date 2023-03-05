# S.S. Law

This is a lightweight system/template for creating your own static website, based upon the setup for [my website](https://syndamia.com), whose source is available in [GitLab](https://gitlab.com/Syndamia/syndamiadotcom).

You create webpages in Markdown, in the (fork of the) repository, which you'll have to the commit and push.
Then they're converted and stapled together with [ssg](https://romanzolotarev.com/ssg.html) and [lowdown](https://kristaps.bsd.lv/lowdown/) and everything together is automatically "deployed" by a couple of scripts.
Finally, if you desire more advanced editing of your generated pages, you can use [AWK scripts](#awk).

However, remember, this is meant to be as simple as possible, while being very expandable.
You're **encouraged** to figure out what everything does and to modify it according to your needs.
Everything that comes out of the box is just default configurations, remove what you don't need and replace what you don't like.

## How it all works and what are files for

The main tools that power everything are ssg, lowdown and awk.
Essentially, ssg takes all of your website files, where

- Markdown pages are converted into `.html` files via lowdown, and then ssg inserts `_header.html` and `_footer.html` at the top and bottom of every such `.html` file
- and all other files are taken as-is,

and puts everything in a nice folder (`public`).
Afterwards, all AWK scripts are ran on all `.html` files inside that folder.

### Scripts

Inside the `generate-scripts` folder you'll find the shell scripts, which automate the creation of your webpages.
The `get-` scripts download ssg and lowdown, while `generate-site.sh` puts everything together to create those pages.

`.gitlab-ci.yml` and `.github/workflows/github-ci.yml` are your pipeline configurations.
With them GitLab and GitHub (respectively) can generate your site automatically, with their servers, and host it for you too.
`deploy.sh` is a more manual script which can be used to generate your site locally.
All three use the stuff in `generate-scripts`.

`.ssgignore` has files and folder which will not be used for site generation.

### AWK

As mentioned, the preferred way to do special formatting to your generated (`html`) pages is via AWK scripts.
With an AWK script, you specify what part of the document (current line) you want to modify, and then how to modify it.

An example use case would be to add your own syntax, lets say you want to type `&&gb` in Markdown, and in the HTML page that should be replaced with some HTML code, containing the image of the British flag.
Or alternatively, what if you want to automatically insert an image next to every occurrence of a word, without having to specify it in the Markdown file.

The only caveat is that you have to write scripts in a specific manner.
First are ran all scripts that start with a capital letter, then all of those starting with `_` and finally all of those with a lowercase letter.
Your script names cannot start with other characters and you mustn't rely on ordering of scripts.

You also shouldn't print the current line, that is done with the `_print.awk` script.
So, before being printed, you modify the current line in your scripts with a capital letter in their name, then `_print.awk` prints the current lines, and finally your scripts with lower case letter do some post-priting procedures.
This is done, because all scripts are combined into one, for improved efficiency.

Good resources for the language are

- [The AWK programming language](https://archive.org/details/pdfy-MgN0H1joIoDVoIC7)
- [Awk -- A Pattern Scanning and Processing Language](https://www.researchgate.net/publication/2425273_Awk_---_A_Pattern_Scanning_and_Processing_Language_Second_Edition)

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
  2. Clone it
  3. Run the `deploy.sh` script
  
  - The website will be available inside the `public` folder.
    You can directly just view and open the generated `.html` files, but it's better to an HTTP server.

### Configuring pipelines

There are a couple of variables which control how your website will be generated, via the pipelines:

- `SOURCE_FOLDER`: The directory where the pages for your website are located (relative to the repository).
  By default it's `.`, meaning exactly where all other repo files are.
- `AWK_FOLDER`: Location of your awk scripts (relative to the repository).
- `SSG_TITLE`: The title that will be included in all of your pages
- `SSG_BASE_URL`: The base URL (`https://website.com`) of your website

Depending on how you generate the website, those variables will be available either in:

- `.github/workflows/github-ci.yml` if using GitHub
- `.gitlab-ci.yml` if using GitLab
- `deploy.sh` if generating manually

## Background

This template is pretty much my [website](https://gitlab.com/Syndamia/syndamiadotcom) generation stack, extracted as a standalone template, with some pipelines and nice default configurations.
However, I was introduced to ssg and lowdown from [Wolfgang's Channel](https://www.youtube.com/channel/UCsnGwSIHyoYN0kiINAGUKxg) on YouTube, and more specifically, from his [tutorial](https://www.youtube.com/watch?v=N_ttw2Dihn8).

The name is a word-play on the main three technologies used: **SS**g, **L**owdown, **aw**k
