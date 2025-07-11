export interface ChatMessage {
  text: string;
  from: "user" | "agent" | "system";
  time: string;
}

export interface IncomingSocketMessage {
  from: string | number;
  message: string;
}