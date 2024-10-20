import { Controller, Get } from '@nestjs/common';
import { AppService } from './app.service';
import { Observable } from 'rxjs';
import { UserReply } from './user/user';

@Controller()
export class AppController {
  constructor(private readonly appService: AppService) {}

  @Get('/users')
  findAllUser(): Observable<UserReply> {
    return this.appService.findAllUsers();
  }
}
