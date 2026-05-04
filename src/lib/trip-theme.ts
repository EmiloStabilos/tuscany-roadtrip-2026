export type TripTheme = {
  palette: {
    background: string;
    surface: string;
    textPrimary: string;
    textMuted: string;
    accent: string;
    accentSoft: string;
    frame: string;
  };
  typography: {
    display: string;
    body: string;
    caption: string;
  };
  effects: {
    imageOverlay: string;
    cardShadow: string;
    borderRadius: string;
  };
  layout: {
    contentMaxWidth: string;
    editorialGap: string;
  };
};

export const romanticLifestyleTheme: TripTheme = {
  palette: {
    background: '#F6F0E8',
    surface: '#FFF9F2',
    textPrimary: '#3A2A22',
    textMuted: '#7D675A',
    accent: '#B66A4D',
    accentSoft: '#D9B49F',
    frame: '#E9D9CB',
  },
  typography: {
    display: '"Cormorant Garamond", serif',
    body: '"Inter", sans-serif',
    caption: '"Libre Baskerville", serif',
  },
  effects: {
    imageOverlay: 'linear-gradient(180deg, rgba(58,42,34,0.08) 0%, rgba(58,42,34,0.35) 100%)',
    cardShadow: '0 12px 32px rgba(88, 60, 44, 0.10)',
    borderRadius: '1rem',
  },
  layout: {
    contentMaxWidth: '1200px',
    editorialGap: '2rem',
  },
};
