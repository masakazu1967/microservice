import { Inject, Injectable, OnModuleInit } from '@nestjs/common';
import { ClientGrpcProxy } from '@nestjs/microservices';
import { Observable } from 'rxjs';
import { UserReply, UserServiceClient } from './user/user';

@Injectable()
export class AppService implements OnModuleInit {
  private userService: UserServiceClient;

  constructor(@Inject('USER_PACKAGE') private client: ClientGrpcProxy) {}

  onModuleInit() {
    this.userService = this.client.getService<UserServiceClient>('UserService');
  }

  findAllUsers(): Observable<UserReply> {
    return this.userService.findAll({});
  }
}
