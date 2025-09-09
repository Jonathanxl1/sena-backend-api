import { Inject, Injectable } from '@nestjs/common';
import config from './config/config';
import { ConfigType } from '@nestjs/config';

@Injectable()
export class AppService {
  constructor(
    @Inject(config.KEY) private configService: ConfigType<typeof config>,
  ) {}

  getService(): string {
    return this.configService.database.database;
  }
}
