import { Controller } from '@nestjs/common';
import { GrpcMethod } from '@nestjs/microservices';
import { User, UserReply } from './user';

@Controller()
export class UserController {
  @GrpcMethod('UserService', 'FindAll')
  findAll(): UserReply {
    const users: User[] = [
      { id: 1, email: 'john@example.com', name: 'John' },
      { id: 2, email: 'doe@example.com', name: 'Doe' },
    ];
    return { users };
  }
}
