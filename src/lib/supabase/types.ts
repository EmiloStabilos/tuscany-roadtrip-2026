export type Json = string | number | boolean | null | { [key: string]: Json | undefined } | Json[];

export type Database = {
  public: {
    Tables: {
      trips: {
        Row: {
          id: string;
          slug: string;
          name: string;
          start_date: string;
          end_date: string;
          timezone: string;
          status: 'draft' | 'active' | 'archived';
        };
      };
      days: {
        Row: {
          id: string;
          trip_id: string;
          day_number: number;
          date: string;
          title: string | null;
          summary: string | null;
        };
      };
      stops: {
        Row: {
          id: string;
          trip_id: string;
          day_id: string | null;
          name: string;
          category: 'town' | 'winery' | 'museum' | 'food' | 'scenic' | 'lodging';
          address: string | null;
          notes: string | null;
        };
      };
    };
  };
};
