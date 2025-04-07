pub const std = @import("std");
const Allocator = std.mem.Allocator;

pub fn Observer(comptime T: type) type {
    return struct {
        const Self = @This();

        /// Observer function type
        pub const ObserverFn = *const fn (event: T) void;

        /// Internal linked list node for storing observers
        const Node = struct {
            observer: ObserverFn,
            next: ?*Node,
        };

        allocator: Allocator,
        observers: ?*Node,

        /// Initialize a new subject
        pub fn init(allocator: Allocator) Self {
            return .{
                .allocator = allocator,
                .observers = null,
            };
        }

        /// Clean up all allocated observer nodes
        pub fn deinit(self: *Self) void {
            var current = self.observers;
            while (current) |node| {
                const next = node.next;
                self.allocator.destroy(node);
                current = next;
            }
            self.observers = null;
        }

        /// Subscribe an observer to this subject
        pub fn subscribe(self: *Self, observer: ObserverFn) !void {
            // Check if observer is already subscribed
            var current = self.observers;
            while (current) |node| {
                if (node.observer == observer) {
                    return; // Already subscribed
                }
                current = node.next;
            }

            // Create a new node
            const node = try self.allocator.create(Node);
            node.* = .{
                .observer = observer,
                .next = self.observers,
            };
            self.observers = node;
        }

        /// Unsubscribe an observer from this subject
        pub fn unsubscribe(self: *Self, observer: ObserverFn) void {
            if (self.observers == null) return;

            // Special case: first node matches
            if (self.observers.?.observer == observer) {
                const to_remove = self.observers.?;
                self.observers = to_remove.next;
                self.allocator.destroy(to_remove);
                return;
            }

            // Check the rest of the list
            var current = self.observers;
            while (current) |node| {
                const next = node.next;
                if (next != null and next.?.observer == observer) {
                    node.next = next.?.next;
                    self.allocator.destroy(next.?);
                    return;
                }
                current = node.next;
            }
        }

        /// Notify all observers about an event
        pub fn notify(self: *Self, event: T) void {
            var current = self.observers;
            while (current) |node| {
                node.observer(event);
                current = node.next;
            }
        }
    };
}
