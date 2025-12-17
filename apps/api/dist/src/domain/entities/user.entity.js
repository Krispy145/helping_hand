"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.User = exports.UserRole = void 0;
var UserRole;
(function (UserRole) {
    UserRole["USER"] = "USER";
    UserRole["ADMIN"] = "ADMIN";
    UserRole["MODERATOR"] = "MODERATOR";
})(UserRole || (exports.UserRole = UserRole = {}));
class User {
    id;
    email;
    password;
    name;
    role;
    createdAt;
    updatedAt;
    constructor(partial) {
        Object.assign(this, partial);
    }
}
exports.User = User;
//# sourceMappingURL=user.entity.js.map