/**
 * Single source of truth for biographical data. The home page renders a compact
 * overview from these records; the CV page renders the full detail.
 */
import type { ImageMetadata } from 'astro';
import logoTTU from '../assets/logo-texas-tech.png';
import logoBUP from '../assets/logo-bup.png';

export interface Interest {
  title: string;
  blurb: string;
}

export interface Education {
  degree: string;
  institution: string;
  location: string;
  dates: string;
  gpa: string;
  thesis: string;
  advisor?: string;
  logo: ImageMetadata;
  logoAlt: string;
}

export interface Position {
  title: string;
  org?: string;
  dates: string;
  /** Secondary line, e.g. supervisor or collaborator. */
  meta?: string;
  bullets: string[];
}

export const tagline = {
  lead: 'Disaster risk, remote sensing, GIS, and machine learning:',
  rest: 'mapping how landscapes change and who bears the cost.',
};

export const interestsStatement = 'Earth observation for disaster risk, land change, and the communities exposed to both.';

export const interests: Interest[] = [
  {
    title: 'Natural Hazards & Disaster Risk',
    blurb:
      'Storms, floods, and extreme heat, and the question of who bears their cost: post-storm recovery, compound hazard exposure, and hazard mapping.',
  },
  {
    title: 'Social Vulnerability & Climate Adaptation',
    blurb:
      'Linking social vulnerability indices, census demographics, and infrastructure data to understand which communities are exposed and how they recover.',
  },
  {
    title: 'Remote Sensing & GIS',
    blurb:
      'Landsat, Sentinel, MODIS, and VIIRS Black Marble imagery processed in Google Earth Engine and ArcGIS Pro at regional scale.',
  },
  {
    title: 'Land Cover & Coastal Wetlands',
    blurb:
      'Seasonal, multi-decadal classification of deltas and tidal wetlands, and how well a framework built for one delta transfers to another.',
  },
  {
    title: 'Machine Learning & GeoAI',
    blurb:
      'Random Forest, gradient boosting, and interpretable models for land cover classification and the drivers of land surface temperature.',
  },
  {
    title: 'Spatial Analysis',
    blurb:
      'Spatial and quantile regression, Moran’s I and LISA clustering, and PostGIS databases applied to hazard and equity questions.',
  },
];

export const education: Education[] = [
  {
    degree: 'M.S. in Geography and Environmental Studies',
    institution: 'Texas Tech University',
    location: 'Lubbock, TX',
    dates: 'Aug 2025 – May 2027 (expected)',
    gpa: '3.863',
    thesis:
      'Transferability of a Google Earth Engine Land Cover Classification Framework Between the Ganges and Mississippi Deltas',
    advisor: 'Dr. Chao Xu',
    logo: logoTTU,
    logoAlt: 'Texas Tech University seal',
  },
  {
    degree: 'B.S.S. in Disaster and Human Security Management',
    institution: 'Bangladesh University of Professionals',
    location: 'Dhaka, Bangladesh',
    dates: 'Jan 2020 – Jan 2024',
    gpa: '3.90 / 4.00',
    thesis:
      'Assessing and Prediction of Spatio-temporal Changes of LULC using CA-ANN Model and its Socioeconomic Implications for Coastal Bangladesh: A Case Study of Dacope Sub-district',
    logo: logoBUP,
    logoAlt: 'Bangladesh University of Professionals logo',
  },
];

export const researchExperience: Position[] = [
  {
    title: 'Graduate Research',
    org: 'Department of Geosciences, Texas Tech University',
    dates: 'Aug 2025 – Present',
    meta: 'Supervisor: Dr. Chao Xu',
    bullets: [
      'Conducted a spatial and quantile analysis of infrastructure precarity and social vulnerability during Winter Storm Uri in Harris County, using VIIRS Black Marble nighttime light deficit data against ACS and social vulnerability variables; methods included Spearman correlation, OLS with clustered standard errors, robust regression, quantile regression, Moran’s I, and a spatial lag model.',
      'Developing a Landsat random forest classification of tidal flats and wetlands in the Ganges Delta in Google Earth Engine, using manually interpreted reference samples and a revised land-cover scheme.',
    ],
  },
  {
    title: 'Independent Research Collaboration',
    dates: '2025 – Present',
    meta: 'With M. Shahriar Sonet, Ph.D. candidate in Geospatial Information Sciences, University of Texas at Dallas',
    bullets: [
      'Conducting a census-tract-level analysis of compound heat-flood exposure and social vulnerability across Houston, Miami, and Norfolk, integrating NFIP flood claims, CDC social vulnerability data, NHGIS tract crosswalks, and GEE-derived land surface temperature.',
    ],
  },
  {
    title: 'Research Consultant, Remote Sensing Division',
    org: 'Center for Environmental and Geographic Information Services (CEGIS), Dhaka, Bangladesh',
    dates: 'Jan 2024 – Dec 2024',
    bullets: [
      'Created, updated, and digitized land use / land cover maps for Chittagong division.',
      'Georeferenced satellite imagery for digitization.',
      'Managed databases and resolved topological errors.',
      'Conducted crop pattern analysis.',
    ],
  },
  {
    title: 'Research Assistant, Geospatial Health Studies Division',
    org: 'Center for Health Innovation, Research, Action and Learning – Bangladesh (CHIRAL)',
    dates: 'Apr 2023 – Dec 2023',
    bullets: [
      'Collected spatial and non-spatial data and conducted thematic analysis on environmental factors influencing dengue outbreaks, using GIS for disease mapping and risk assessment.',
      'Trained interns on mobile data collection and GIS tools (KoboToolbox, ArcGIS).',
      'Analyzed and visualized data in Excel and SPSS, producing charts and infographics for project reporting.',
    ],
  },
];

export const teachingExperience: Position[] = [
  {
    title: 'Graduate Teaching Assistant',
    org: 'Department of Geosciences, Texas Tech University',
    dates: 'Aug 2025 – Present',
    meta: 'Courses: Introduction to GIS; Regional Geography of the World; Global Environmental Science',
    bullets: ['Grade coursework and exams.', 'Assist students during lab sessions.', 'Hold weekly office hours.'],
  },
];

export const awards: string[] = [
  'Graduate Teaching Assistantship, Texas Tech University (Aug 2025 – Present)',
  'Department of Geosciences Scholarship, Texas Tech University (Fall 2026)',
  'Graduate Field Experience Fellowship, Texas Tech University (Summer 2026)',
  'Gary Elbow Scholarship, Department of Geosciences, Texas Tech University (Fall 2025)',
];

export const skills: { label: string; items: string }[] = [
  { label: 'GIS & Remote Sensing', items: 'ArcGIS Pro, ArcMap, QGIS, Google Earth Engine, ENVI' },
  { label: 'Programming & Databases', items: 'Python, JavaScript (Google Earth Engine), R, SQL/PostGIS' },
  { label: 'Statistics', items: 'SPSS, Jamovi' },
  { label: 'Remote Sensing Data', items: 'Landsat, Sentinel, MODIS, VIIRS Black Marble' },
  { label: 'Data Collection', items: 'KoboToolbox' },
  { label: 'Graphics', items: 'Adobe Illustrator, Canva' },
];

export const languages: { label: string; items: string }[] = [
  { label: 'Bengali', items: 'Native' },
  { label: 'English', items: 'Fluent (IELTS overall band 7.5)' },
];

export const contact = {
  email: 'mdjubierahammed@gmail.com',
  location: 'Lubbock, TX, USA',
  linkedin: { name: 'Md Jubier Ahammed', url: 'https://www.linkedin.com/in/md-jubier-ahammed/' },
  orcid: { id: '0009-0005-2011-8502', url: 'https://orcid.org/0009-0005-2011-8502' },
  scholar: { name: 'Google Scholar profile', url: 'https://scholar.google.com/citations?user=AJYNh74AAAAJ' },
};
