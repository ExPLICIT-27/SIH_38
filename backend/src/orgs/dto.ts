import { ApiProperty } from '@nestjs/swagger';

export class CreateOrgDto {
  @ApiProperty({ example: 'Green Panchayat' })
  name!: string;

  @ApiProperty({ example: 'panchayat' })
  type!: string;

  @ApiProperty({ enum: ['SELLER', 'BUYER', 'BOTH'], required: false })
  mode?: 'SELLER' | 'BUYER' | 'BOTH';

  @ApiProperty({ example: '0xabc...', required: false })
  walletAddress?: string;
}

export class SetWalletDto {
  @ApiProperty({ example: '0xabc...' })
  walletAddress!: string;
}


