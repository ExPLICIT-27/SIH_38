import { Body, Controller, Get, Param, Post } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';
import { ApiTags } from '@nestjs/swagger';
import { Logger } from '@nestjs/common';
import { ChainService } from '../chain/chain.service';

@ApiTags('Market')
@Controller('v1/market')
export class MarketController {
  private readonly logger = new Logger(MarketController.name);
  constructor(
    private prisma: PrismaService,
    private chain: ChainService,
  ) {}

  @Post('list')
  async list(
    @Body()
    body: {
      creditAddress: string;
      tokenId: number;
      pricePerUnit: number;
      amount: number;
    },
  ) {
    this.logger.log(
      `Create listing tokenId=${body.tokenId} price=${body.pricePerUnit} amount=${body.amount}`,
    );
    const listing = await this.prisma.listing.create({
      data: {
        creditAddress: body.creditAddress,
        tokenId: body.tokenId,
        pricePerUnit: body.pricePerUnit,
        remaining: body.amount,
      },
    });
    return listing;
  }

  @Get('listings')
  async listings() {
    this.logger.log('List listings');
    return this.prisma.listing.findMany({ orderBy: { createdAt: 'desc' } });
  }

  @Post('buy/:id')
  async buy(
    @Param('id') id: string,
    @Body()
    body: {
      buyerWallet: string;
      amount: number;
      creditAddress: string;
      tokenId: string;
    },
  ) {
    const listing = await this.prisma.listing.findUnique({ where: { id } });
    if (!listing || listing.status !== 'ACTIVE')
      return { error: 'Listing not active' };
    if (listing.remaining < body.amount)
      return { error: 'Insufficient amount' };

    // For demo: no on-chain transfer of ERC1155; just record an Order.
    this.logger.log(
      `Buy listing id=${id} amount=${body.amount} buyer=${body.buyerWallet}`,
    );
    const order = await this.prisma.order.create({
      data: {
        listingId: listing.id,
        buyerWallet: body.buyerWallet,
        amount: body.amount,
        txHash: 'demo',
      },
    });
    const remaining = listing.remaining - body.amount;
    await this.prisma.listing.update({
      where: { id },
      data: { remaining, status: remaining === 0 ? 'SOLD_OUT' : 'ACTIVE' },
    });
    return order;
  }
}
