export declare class CreateOrgDto {
    name: string;
    type: string;
    mode?: 'SELLER' | 'BUYER' | 'BOTH';
    walletAddress?: string;
}
export declare class SetWalletDto {
    walletAddress: string;
}
