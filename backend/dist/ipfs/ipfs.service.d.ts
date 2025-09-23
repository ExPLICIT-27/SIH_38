export declare class IpfsService {
    private readonly logger;
    private readonly token;
    pinFile(filePath: string, fileName: string): Promise<string | null>;
}
