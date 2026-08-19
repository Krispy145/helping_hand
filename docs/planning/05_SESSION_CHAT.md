# Session & Chat Implementation (Phase 0 Core)

## Status: Implemented ✅

## Overview
This feature enables real-time communication between a Helper and a Requestor after a request is accepted. It uses a WebSocket connection to facilitate instant messaging.

## Architecture

### Backend (`apps/api`)
- **Session Module**: Handles the creation of sessions when a request is accepted.
- **Gateway**: `ChatGateway` using `socket.io` handles real-time events (`joinSession`, `sendMessage`, `newMessage`).
- **Data Model**:
  - `Session`: Links a `Request` to a `User` (Helper). has many `ChatMessage`s.
  - `ChatMessage`: content, senderId, timestamp.

### Frontend (`apps/mobile`)
- **ChatScreen**: UI for displaying messages and input field.
- **ChatRepository**:
  - `createSession(requestId)`: POST `/sessions`
  - `getMessages(sessionId)`: GET `/sessions/:id/messages`
- **ChatProvider**:
  - Manages WebSocket connection using `socket_io_client`.
  - Connects to `F.apiBaseUrl` namespace `/chat`.
  - Listens for `new_message` events to update the message list in real-time.

## Key Decisions
- **Socket.io**: Chosen for reliability and fallback support over raw WebSockets.
- **Optimistic UI**: Messages are effectively "optimistic" in the sense that the list updates on incoming socket events.
- **Separation of Concerns**: Repository handles REST (history/creation), Provider handles Socket (real-time).

## Next Steps (Future Phases)
- [x] Push Notifications for new messages when app is backgrounded.
- [ ] Message status (sent, delivered, read).
- [ ] Typing indicators.
