export interface ChatMessage {
  text: string;
  from: "user" | "agent" | "system";
  time: string;
}

export interface IncomingSocketMessage {
  from: string | number;
  message: string;
}

export interface Chat {
  id: string;
  name: string;
  online: boolean;
  time: string;
  messages: ChatMessage[];
}