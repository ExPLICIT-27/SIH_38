export declare class MintDto {
    creditAddress: string;
    to: string;
    id: string;
    amount: string;
}
export declare class RetireDto {
    creditAddress: string;
    id: string;
    amount: string;
    reason: string;
}
export declare class AnchorDto {
    registryAddress: string;
    uploadId: string;
    sha256: string;
    cid?: string;
}
