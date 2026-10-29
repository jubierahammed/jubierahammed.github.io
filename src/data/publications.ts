/**
 * Single source of truth for publications. Used by the Publications page (full
 * entries), the CV page (citations), and the home page (featured titles).
 */
export type PublicationKind = 'published' | 'preprint' | 'in-preparation' | 'conference';

export interface PublicationLink {
  label: string;
  href: string;
}

export interface Publication {
  id: string;
  kind: PublicationKind;
  title: string;
  /** Citation-style author list; "*" marks the corresponding author. */
  authors: string;
  /** Journal or conference name. */
  venue?: string;
  /** Volume, issue, and article number for published papers, e.g. "15(11), 491". */
  citation?: string;
  year?: number;
  /** Short status label shown above the title on the Publications page. */
  status: string;
  doi?: string;
  pdf?: string;
  /** Replaces the default DOI and PDF links on the Publications page. */
  links?: PublicationLink[];
  abstract?: string;
  narrative?: string;
  methods?: string;
  /** Show on the home page's Featured Research list. */
  featured?: boolean;
  /** Award or recognition line, e.g. for a conference poster. */
  award?: { label: string; href: string };
}

export const publications: Publication[] = [
  {
    id: 'post-storm-recovery',
    kind: 'published',
    featured: true,
    title:
      'What Daily Nighttime Lights Can and Cannot Show About Power Outage and Recovery: Winter Storm Uri in Harris County, Texas',
    authors: 'Ahammed, M.J., Xu, C.*, Xu, Y., Zhou, H.',
    venue: 'ISPRS International Journal of Geo-Information',
    citation: '15(11), 491',
    year: 2026,
    status: 'Published · ISPRS International Journal of Geo-Information, 2026',
    doi: '10.3390/ijgi15110491',
    links: [
      { label: 'Read the paper', href: 'https://doi.org/10.3390/ijgi15110491' },
      { label: 'PDF', href: '/papers/ahammed-2026-uri-nighttime-lights-ijgi.pdf' },
    ],
    narrative: "When the Texas grid failed during Winter Storm Uri, satellites recorded the lights going out. This paper asks how much daily nighttime-light data can actually tell us about outage and recovery, and where it falls short. Using NASA Black Marble imagery over Harris County, it shows that outage extent is visible but recovery timing depends heavily on how the data are processed, and that apparent links to social vulnerability need to be tested against ordinary night-to-night variation before they can be trusted.",
    abstract: "Daily nighttime light (NTL) images are widely used to map power outages and recovery, but clouds and quality screening leave gaps. We examined what NASA Black Marble data show about the February 2021 Winter Storm Uri outage in Harris County, Texas. When only high-quality retrievals were used, 16 February was the only usable night during the outage, and the next were 19 to 21 February. On 16 February, 5112 of 13,846 developed pixels (37%) were below half their pre-storm brightness, and 92% of those with an observed return were lit by 21 February. Return dates between these nights are unobservable. Recovery dates from a detector-based workflow depend on smoothing, persistence and aggregation choices; in a controlled experiment with known recovery dates and flag-0 observations only, an unsmoothed rule requiring three consecutive calendar nights has a median detection delay of 12 to 15 days. Compared with 20 ordinary clear nights, 16 February dimming was far more extensive and clustered. However, the estimated average total impact of the Social Vulnerability Index was 10.6 percentage points of reference radiance (95% interval −32.0 to 49.8), within the range estimated on ten ordinary pre-storm nights (−31.9 to 26.8). Single-night community comparisons need an ordinary-night baseline.",
  },
  {
    id: 'compound-heat-flood',
    kind: 'preprint',
    featured: true,
    title:
      'Social Vulnerability and Compound Heat-Flood Exposure in Houston, Miami, and Norfolk: A Census-Tract-Level Analysis',
    authors: 'Ahammed, M.J.*, Sonet, M.S.',
    venue: 'Regional Environmental Change',
    status: 'Preprint · Under review, Regional Environmental Change',
    doi: '10.21203/rs.3.rs-10349570/v1',
    pdf: '/papers/ahammed-sonet-2026-compound-heat-flood-exposure-preprint.pdf',
    narrative:
      'Most hazard research looks at one risk at a time. This project asked a different question: which communities face extreme heat and flood risk simultaneously, across three coastal cities with very different climates and histories. By combining FEMA flood claims, CDC social vulnerability data, and satellite-derived land surface temperature at the census-tract level, the analysis identifies where compound exposure concentrates, and whether it falls disproportionately on already-vulnerable populations.',
    abstract:
      "Urban coastal communities in the United States face simultaneous chronic exposure to extreme heat and flooding, yet these hazards are typically studied and managed in isolation. This study examines whether co-located heat and flood exposure, termed compound exposure potential, is disproportionately concentrated in socially vulnerable census tracts across three U.S. coastal cities with contrasting flood mechanisms: Houston (Texas), Miami (Florida), and the Norfolk cluster (Virginia). Daytime land surface temperature composites from Landsat 8 and Landsat 9 imagery (2019 to 2023) and National Flood Insurance Program paid claim density are combined to classify 1,383 census tracts into four compound exposure classes. Social vulnerability is measured using the Centers for Disease Control and Prevention Social Vulnerability Index 2022 and tested as a predictor of compound exposure using ordinary least squares, logistic, quantile, and diagnostic-driven spatial regression. Compound-high tracts show significantly higher social vulnerability (mean 0.67 versus 0.51 for low-exposure tracts), lower median household income (68,037 versus 88,155 US dollars), and more pre-1980 housing. Social vulnerability significantly predicts compound exposure (odds ratio 4.1), and the association strengthens among the most exposed tracts and varies by city, strongest in Miami, significant but attenuated in Houston, where Hurricane Harvey's inundation obscures the chronic flood signal, and non-significant in Norfolk. Bivariate spatial clustering and geographically weighted regression show that Houston's modest citywide association masks locally concentrated, substantially stronger relationships in specific neighborhoods. Compound heat-flood exposure tracks social inequality additively rather than multiplicatively, with the most exposed tracts consistently the most socially vulnerable.",
    methods: 'R, Google Earth Engine, NFIP claims data, CDC SVI, NHGIS tract crosswalks',
  },
  {
    id: 'ganges-wetlands-paper',
    kind: 'in-preparation',
    title: 'Tracking Coastal Wetland Dynamics in the Ganges Delta from 1985–2026 Using Google Earth Engine',
    authors: 'Xu, C., Ahammed, M.J.',
    status: 'In preparation',
  },
  {
    id: 'swaag-2026-poster',
    kind: 'conference',
    title: 'Spatial Pattern of Post-storm Recovery Revealed by Nighttime Light: Evidence from Harris County, Texas',
    authors: 'Ahammed, M.J., Xu, C., Xu, Y., Zhou, H.',
    venue:
      'Poster, Southwest Association of American Geographers (SWAAG) Annual Meeting, Student Competition, October 2, 2026',
    status: 'Conference poster',
    award: { label: '2nd Place, Graduate Poster', href: '/awards/#swaag-2026' },
  },
  {
    id: 'icesrm-dacope',
    kind: 'conference',
    title:
      "Dynamic Trends in Land Use and Land Cover Change with QADI Validation: Exploring the Shifts in Shrimp Farming and Socioeconomic Implications in Coastal Bangladesh's Dacope Sub-district",
    authors: 'Ahammed, M.J.',
    venue: 'International Conference on Environmental Science and Resource Management (ICESRM)',
    status: 'Conference presentation',
  },
];

/** Full author list for display on the Publications page (no citation abbreviations); "*" marks the corresponding author. */
export const displayAuthors: Record<string, string> = {
  'post-storm-recovery': 'Md Jubier Ahammed, Chao Xu*, Yaping Xu, Hanlin Zhou',
  'compound-heat-flood': 'Md Jubier Ahammed*, M Shahriar Sonet',
};
