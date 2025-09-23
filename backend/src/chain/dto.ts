import { ApiProperty } from '@nestjs/swagger';

export class MintDto {
  @ApiProperty() creditAddress!: string;
  @ApiProperty({ example: '0x...' }) to!: string;
  @ApiProperty({ example: '1' }) id!: string;
  @ApiProperty({ example: '100' }) amount!: string;
}

export class RetireDto {
  @ApiProperty() creditAddress!: string;
  @ApiProperty({ example: '1' }) id!: string;
  @ApiProperty({ example: '40' }) amount!: string;
  @ApiProperty({ example: 'demo' }) reason!: string;
}

export class AnchorDto {
  @ApiProperty() registryAddress!: string;
  @ApiProperty() uploadId!: string;
  @ApiProperty({ description: 'sha256 hex of uploaded file' }) sha256!: string;
  @ApiProperty({ required: false }) cid?: string;
}


