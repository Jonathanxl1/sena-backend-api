import { Injectable, NotFoundException } from '@nestjs/common';
import { CreateUserDto } from './dto/create-user.dto';
import { UpdateUserDto } from './dto/update-user.dto';
import { InjectRepository } from '@nestjs/typeorm';
import { User } from './entities/user.entity';
import { Repository } from 'typeorm';

@Injectable()
export class UsersService {
  constructor(
    @InjectRepository(User) private userRepository: Repository<User>,
  ) {}

  async create(createUserDto: CreateUserDto) {
    const user = await this.userRepository.create({
      ...createUserDto,
    });
    delete user.createdAt;
    delete user.updateAt;

    return this.userRepository.save(user);
  }

  async findAll() {
    try {
      const users = await this.userRepository.find({
        select: ['id', 'email', 'address', 'lastname', 'work_role', 'name'],
      });
      return users;
    } catch (error) {
      console.error(error);
    }
  }

  async findOne(id: number) {
    try {
      const [user] = await this.userRepository.findBy({ id });
      if (!user) {
        throw new NotFoundException(`Resource with ID ${id} not found`);
      }
      delete user?.createdAt;
      delete user?.updateAt;
      return user;
    } catch (error) {
      console.error(error);
      throw new NotFoundException(`Resource with ID ${id} not found`);
    }
  }

  async update(id: number, updateUserDto: UpdateUserDto) {
    try {
      let [user] = await this.userRepository.findBy({ id });
      user = { ...user, ...updateUserDto };
      this.userRepository.save(user);
    } catch (error) {
      console.error(error);
      throw new NotFoundException('Invalid resource');
    }
  }

  async remove(id: number) {
    const result = await this.userRepository.delete(id);
    if (result.affected == 0) {
      throw new NotFoundException(`Resource with ID ${id} not found`);
    }
    return {
      status: 200,
      message: `User with ID ${id} deleted`,
    };
  }
}
