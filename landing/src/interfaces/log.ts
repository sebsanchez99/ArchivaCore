export interface Log {
    id: string;
    table: string;
    register: string;
    type: string;
    description: string;
    date: Date; 
    user: string | null;
    username: string | null;
    oldData:Record<string, any> | null;
    newData: Record<string, any> | null;
}