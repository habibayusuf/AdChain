import { describe, it, expect, beforeEach, vi } from 'vitest';

// Mock the necessary objects and functions
const mockChain = {
  mineBlock: vi.fn(),
};

const mockTx = {
  contractCall: vi.fn(),
};

const mockTypes = {
  list: vi.fn(),
  ascii: vi.fn(),
  bool: vi.fn(),
  principal: vi.fn(),
};

describe("User data management", () => {
  beforeEach(() => {
    vi.clearAllMocks();
  });
  
  it("Ensure that user can set and retrieve their data", async () => {
    // Arrange
    const wallet_1 = { address: 'ST1PQHQKV0RJXZFY1DGX8MNSNYVE3VGZJSRTPGZGM' };
    
    // Mock the contract call responses
    mockChain.mineBlock.mockReturnValueOnce({
      receipts: [{ result: { success: true } }],
      height: 2
    }).mockReturnValueOnce({
      receipts: [{ result: { success: true, value: { 'data-sharing-enabled': true } } }],
      height: 3
    });
    
    // Act
    let block = mockChain.mineBlock([
      mockTx.contractCall('user-data', 'set-user-data', [
        mockTypes.list([mockTypes.ascii("male"), mockTypes.ascii("18-35"), mockTypes.ascii("tech-savvy")]),
        mockTypes.bool(true)
      ], wallet_1.address)
    ]);
    
    // Assert
    expect(block.receipts.length).toBe(1);
    expect(block.height).toBe(2);
    
    block = mockChain.mineBlock([
      mockTx.contractCall('user-data', 'get-user-data', [mockTypes.principal(wallet_1.address)], wallet_1.address)
    ]);
    expect(block.receipts.length).toBe(1);
    expect(block.height).toBe(3);
    
    const userData = block.receipts[0].result.value;
    expect(userData['data-sharing-enabled']).toBe(true);
  });
  
  it("Ensure that user can toggle data sharing", async () => {
    // Arrange
    const wallet_1 = { address: 'ST1PQHQKV0RJXZFY1DGX8MNSNYVE3VGZJSRTPGZGM' };
    
    // Mock the contract call responses
    mockChain.mineBlock.mockReturnValueOnce({
      receipts: [{ result: { success: true } }, { result: { success: true } }],
      height: 2
    }).mockReturnValueOnce({
      receipts: [{ result: { success: true, value: { 'data-sharing-enabled': false } } }],
      height: 3
    });
    
    // Act
    let block = mockChain.mineBlock([
      mockTx.contractCall('user-data', 'set-user-data', [
        mockTypes.list([mockTypes.ascii("male"), mockTypes.ascii("18-35"), mockTypes.ascii("tech-savvy")]),
        mockTypes.bool(true)
      ], wallet_1.address),
      mockTx.contractCall('user-data', 'toggle-data-sharing', [], wallet_1.address)
    ]);
    
    // Assert
    expect(block.receipts.length).toBe(2);
    expect(block.height).toBe(2);
    
    block = mockChain.mineBlock([
      mockTx.contractCall('user-data', 'get-user-data', [mockTypes.principal(wallet_1.address)], wallet_1.address)
    ]);
    expect(block.receipts.length).toBe(1);
    expect(block.height).toBe(3);
    
    const userData = block.receipts[0].result.value;
    expect(userData['data-sharing-enabled']).toBe(false);
  });
});
