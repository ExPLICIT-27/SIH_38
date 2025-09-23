import {
  Injectable,
  NestInterceptor,
  ExecutionContext,
  CallHandler,
  Logger,
} from '@nestjs/common';
import { Observable } from 'rxjs';
import { tap } from 'rxjs/operators';

@Injectable()
export class LoggingInterceptor implements NestInterceptor {
  private readonly logger = new Logger(LoggingInterceptor.name);

  intercept(context: ExecutionContext, next: CallHandler): Observable<any> {
    const req = context.switchToHttp().getRequest();
    const { method, originalUrl } = req;
    const userId = req.user?.sub || req.user?.id || 'anon';
    const start = Date.now();

    this.logger.log(`${method} ${originalUrl} -> start user=${userId}`);

    return next.handle().pipe(
      tap(() => {
        const res = context.switchToHttp().getResponse();
        const ms = Date.now() - start;
        this.logger.log(
          `${method} ${originalUrl} <- ${res.statusCode} ${ms}ms user=${userId}`,
        );
      }),
    );
  }
}
