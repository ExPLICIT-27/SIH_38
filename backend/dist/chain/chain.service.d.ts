interface Deployed {
    creditAddress: string;
    registryAddress: string;
}
export declare class ChainService {
    private provider;
    private wallet;
    private loadArtifact;
    deployDemo(): Promise<Deployed>;
    mint(creditAddress: string, to: string, id: bigint, amount: bigint): Promise<string>;
    retire(creditAddress: string, id: bigint, amount: bigint, reason: string): Promise<string>;
    anchor(registryAddress: string, uploadId: string, sha256Hex: string, cid: string): Promise<string>;
}
export {};
