import { ApiProperty } from '@nestjs/swagger';

export class SettingsDto {
  @ApiProperty() creditAddress!: string;
  @ApiProperty() registryAddress!: string;
}

export class VerifyDto {
  @ApiProperty() uploadId!: string;
  @ApiProperty() approved!: boolean;
  @ApiProperty({ required: false }) notes?: string;
  @ApiProperty({ required: false }) anchoredTx?: string;
}


