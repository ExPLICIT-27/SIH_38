import { ApiProperty } from '@nestjs/swagger';

export class CreateProjectDto {
  @ApiProperty()
  orgId!: string;

  @ApiProperty({ example: 'Mangrove Plot A' })
  name!: string;

  @ApiProperty({ example: 'mangrove' })
  type!: string;

  @ApiProperty({ example: 1.5, required: false })
  areaHa?: number;
}


