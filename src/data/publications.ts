/**
 * Single source of truth for publications. Used by the Publications page (full
 * entries), the CV page (citations), and the home page (featured titles).
 */
export type PublicationKind = 'preprint' | 'in-preparation' | 'conference';

export interface Publication {
  id: string;
  kind: PublicationKind;
  title: string;
  /** Citation-style author list; "*" marks the corresponding author. */
  authors: string;
  /** Journal or conference name. */
  venue?: string;
  /** Short status label shown above the title on the Publications page. */
  status: string;
  doi?: string;
  pdf?: string;
  abstract?: string;
  narrative?: string;
  methods?: string;
  /** Show on the home page's Featured Research list. */
  featured?: boolean;
}

export const publications: Publication[] = [
  {
    id: 'post-storm-recovery',
    kind: 'preprint',
    featured: true,
    title: 'Spatial Patterns of Post-Storm Recovery Revealed by Nighttime Lights: Evidence from Harris County, Texas',
    authors: 'Ahammed, M.J., Xu, C.*, Xu, Y., Zhou, H.',
    venue: 'ISPRS International Journal of Geo-Information',
    status: 'Preprint · Under review, ISPRS International Journal of Geo-Information',
    doi: '10.20944/preprints202609.0372.v1',
    pdf: '/papers/ahammed-2026-post-storm-recovery-nighttime-lights-preprint.pdf',
    narrative:
      "When the Texas power grid collapsed during Winter Storm Uri in 2021, recovery wasn't uniform, some neighborhoods came back online in hours, others took days. This project used NASA's VIIRS Black Marble nighttime light data as a proxy for outage severity and recovery speed, then tested whether that recovery timeline tracked social vulnerability rather than just infrastructure damage. A spatial lag regression model captured the average pattern, but the more telling result came from quantile regression at the 90th percentile, isolating the slowest-recovering tracts, where the link to vulnerability was strongest. Spatial clustering was confirmed with Moran's I and bivariate LISA mapping.",
    abstract:
      "Winter Storm Uri (February 2021) caused the largest power grid failure in Texas history, with extensive outages in the state's most populous Harris County. This study integrates NASA Black Marble VNP46A2 nighttime light (NTL) observations with the CDC Social Vulnerability Index (SVI) to characterize post-storm recovery across 1,070 census tracts. Recovery was defined as the first day tract-level NTL reached at least 90% of its pre-storm baseline for three consecutive days. Contrary to the expectation that vulnerable communities recover more slowly, spatial regression revealed a weak, statistically significant negative association between SVI and recovery time (β = −0.556, p = 0.050), with spatial dependence also significant (ρ ≈ 0.47). Local Indicators of Spatial Autocorrelation identified significant clusters of slow recovery in lower-SVI suburban areas and fast recovery in higher-SVI urban neighborhoods. This association was sensitive to the recovery definition, reversing signs under longer persistence requirements. The spatial organization of urban infrastructure, rather than vulnerability alone, may plausibly explain these patterns, though not directly testable with available data. These findings caution against assuming a universal vulnerability–recovery relationship in infrastructure disasters and highlight the sensitivity of nighttime-light-based equity assessments to how recovery is operationally defined.",
    methods: "R, spatial lag regression, quantile regression, Moran's I, VIIRS Black Marble nighttime light data",
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
    id: 'icesrm-dacope',
    kind: 'conference',
    title:
      "Dynamic Trends in Land Use and Land Cover Change with QADI Validation: Exploring the Shifts in Shrimp Farming and Socioeconomic Implications in Coastal Bangladesh's Dacope Sub-district",
    authors: 'Ahammed, M.J.',
    venue: 'International Conference on Environmental Science and Resource Management (ICESRM)',
    status: 'Conference presentation',
  },
];

/** Full author list for display on the Publications page (no citation abbreviations). */
export const displayAuthors: Record<string, string> = {
  'post-storm-recovery': 'Md Jubier Ahammed, Chao Xu, Yaping Xu, Hanlin Zhou',
  'compound-heat-flood': 'Md Jubier Ahammed, M Shahriar Sonet',
};
