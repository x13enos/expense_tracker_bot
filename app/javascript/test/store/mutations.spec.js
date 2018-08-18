import mutations from '@store/mutations';

describe('mutations', () => {
  it('updateMessage', () => {
    const state = { message: "New message" };
    mutations.updateMessage(state, "Old message");
    expect(state.message).to.equal("Old message");
  });
});
