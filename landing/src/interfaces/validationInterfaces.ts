export interface ValidationErrors {
    [key: string]: string;
}

export interface Validators {
    [key: string]: (value: string, fields: Record<string, string>) => string | null;
}