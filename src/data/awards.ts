/**
 * Single source of truth for awards, fellowships, and funding, most recent first.
 * The Awards & Honors page renders the full entries; the CV page renders one line each.
 */
import type { GalleryImage } from '../components/Gallery.astro';
import swaagCertificate from '../assets/awards/swaag-2026-certificate.jpg';
import swaagPoster from '../assets/awards/swaag-2026-poster.jpg';
import swaagAward from '../assets/awards/swaag-2026-award.jpg';
import dmxPresenting from '../assets/awards/dmx3-presenting.jpg';
import dmxTeam from '../assets/awards/dmx3-team.jpg';
import forewarnTeam from '../assets/awards/forewarn-team.jpg';

export interface Award {
  id: string;
  title: string;
  org: string;
  dates: string;
  /** One-line form for the CV list. */
  cv: string;
  description?: string;
  links?: { label: string; href: string }[];
  images?: GalleryImage[];
}

export const awards: Award[] = [
  {
    id: 'swaag-2026',
    title: '2nd Place, Graduate Poster',
    org: '2026 SWAAG Student Competition, Southwest Association of American Geographers',
    dates: 'October 2026',
    cv: '2nd Place, Graduate Poster, 2026 SWAAG Student Competition (October 2026)',
    description:
      'Awarded for the poster "Spatial Pattern of Post-storm Recovery Revealed by Nighttime Light: Evidence from Harris County, Texas," the preprint version of the Winter Storm Uri study later published in ISPRS International Journal of Geo-Information.',
    links: [
      { label: 'Published paper', href: '/publications/#post-storm-recovery' },
      { label: 'Research write-up', href: '/research/#uri-nighttime-lights' },
    ],
    images: [
      {
        src: swaagCertificate,
        caption: 'Certificate, 2026 SWAAG Student Competition, 2nd Place, Graduate Poster.',
      },
      { src: swaagPoster, caption: 'Presenting the Winter Storm Uri nighttime-lights poster at SWAAG 2026.' },
      { src: swaagAward, caption: 'Accepting 2nd Place, Graduate Poster, SWAAG 2026.' },
    ],
  },
  {
    id: 'geosciences-scholarship',
    title: 'Department of Geosciences Scholarship',
    org: 'Texas Tech University',
    dates: 'Fall 2026',
    cv: 'Department of Geosciences Scholarship, Texas Tech University (Fall 2026)',
  },
  {
    id: 'field-experience-fellowship',
    title: 'Graduate Field Experience Fellowship',
    org: 'Texas Tech University',
    dates: 'Summer 2026',
    cv: 'Graduate Field Experience Fellowship, Texas Tech University (Summer 2026)',
  },
  {
    id: 'gary-elbow',
    title: 'Gary Elbow Scholarship',
    org: 'Department of Geosciences, Texas Tech University',
    dates: 'Fall 2025',
    cv: 'Gary Elbow Scholarship, Department of Geosciences, Texas Tech University (Fall 2025)',
  },
  {
    id: 'teaching-assistantship',
    title: 'Graduate Teaching Assistantship',
    org: 'Texas Tech University',
    dates: 'Aug 2025 – Present',
    cv: 'Graduate Teaching Assistantship, Texas Tech University (Aug 2025 – Present)',
  },
  {
    id: 'dmx-3',
    title: 'Second Runner-Up, Disaster Management Exercise (DMX 3.0)',
    org: 'Bangladesh University of Professionals',
    dates: '2023',
    cv: 'Second Runner-Up, Disaster Management Exercise (DMX 3.0), Bangladesh University of Professionals (2023)',
    description: 'Team proposal: a GIS and remote sensing based flood recovery framework.',
    links: [{ label: 'Project write-up', href: '/projects/#flood-recovery-framework' }],
    images: [
      {
        src: dmxPresenting,
        caption: 'Presenting our flood recovery framework at DMX 3.0, Bangladesh University of Professionals, 2023.',
      },
      { src: dmxTeam, caption: 'With fellow participants after DMX 3.0, 2023.' },
    ],
  },
  {
    id: 'forewarn-hackathon',
    title: 'Top 16 Team, FOREWARN Disaster Hackathon 1.0',
    org: 'FOREWARN Bangladesh (Start Network), with Open Mapping Hub Asia-Pacific and HOT',
    dates: '2023',
    cv: 'Top 16 Team, FOREWARN Disaster Hackathon 1.0, Bangladesh (2023)',
    description:
      'Selected for proposing a GIS and remote sensing based real-time flood rescue and recovery navigation portal.',
    links: [
      { label: 'Project write-up', href: '/projects/#flood-rescue-portal' },
      { label: 'Event page', href: 'https://startnetwork.org/forewarn-disaster-hackathon-10-bangladesh' },
    ],
    images: [{ src: forewarnTeam, caption: 'With teammates at FOREWARN Disaster Hackathon 1.0, Bangladesh, 2023.' }],
  },
];
