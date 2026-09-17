# jubierahammed.github.io

Personal academic portfolio of Md Jubier Ahammed, built with [Astro](https://astro.build) and deployed on Netlify.

## Working locally

```sh
npm install        # first time only
npm run dev        # start the dev server at http://localhost:4321
npm run build      # production build into dist/
npm run preview    # preview the production build
```

## Where things live

| What | Where |
| --- | --- |
| Home page (bio, education, experience, featured research, contact) | `src/pages/index.astro` |
| Research (thesis, in-preparation work) | `src/pages/research.astro` |
| Publications (preprints, talks) | `src/pages/publications.astro` |
| Projects (coursework write-ups, galleries, scripts) | `src/pages/projects.astro` |
| CV page | `src/pages/cv.astro` |
| Navigation links | `src/components/Header.astro` |
| Colors, fonts, spacing | `src/styles/global.css` |
| Portrait and institution logos | `src/assets/` |
| Project images, one folder per project, numbered `01.jpg`, `02.png`, ... | `src/assets/projects/<slug>/` |
| R and SQL scripts shown on the Projects page | `src/scripts/` |
| Preprint PDFs | `public/papers/` |
| CV PDF | `public/cv/Ahammed_CV.pdf` |

## Common updates

- **Add an image to a project:** drop it into that project's folder in `src/assets/projects/` with the next number, then add its caption to the matching `gallery('<slug>', [...])` list in `src/pages/projects.astro`. The build fails if image and caption counts differ.
- **Update the CV PDF:** replace `public/cv/Ahammed_CV.pdf`.
- **Add a publication:** copy one of the `<ResearchProject ... />` blocks in `src/pages/publications.astro`.
- **Add an experience or award:** edit the `<Entry ... />` blocks in `src/pages/index.astro` and `src/pages/cv.astro`.

Push to `main` and Netlify rebuilds the site automatically.
