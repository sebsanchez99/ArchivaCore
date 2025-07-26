export interface Client {
  id: string;
  name: string;
  fullname: string;
  email: string;
  registerDate: Date; // o Date
  active: boolean;
  initialDate: Date;   // o Date
  planName: string;
}
