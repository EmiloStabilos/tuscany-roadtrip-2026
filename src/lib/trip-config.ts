export type TripConfig = {
  branding: {
    title?: string;
    logoUrl?: string;
    heroImage?: string;
  };
  locale: string;
  currency: string;
  mapDefaults: {
    center?: { lat: number; lng: number };
    zoom: number;
  };
  dateRange?: {
    start: string;
    end: string;
  };
};

export const defaultTripConfig: TripConfig = {
  branding: {},
  locale: 'en-US',
  currency: 'EUR',
  mapDefaults: { zoom: 7 },
};
