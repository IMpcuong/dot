# From source -> modify and itegration each source for learning purpose only: 
# 1. https://github.com/thomdixon/pysha2
# 2. https://stackoverflow.com/questions/7321694/sha-256-implementation-in-python
# 3. https://foss.heptapod.net/pypy/pypy/-/blob/branch/default/lib_pypy/_sha512.py
# 4. https://en.wikipedia.org/wiki/SHA-2#Pseudocode

import copy, struct

def new(msg = None):
    return sha512(msg)

class sha512(object):
  
    # Global constant variables:
    SHA_BLOCKSIZE = 128
    SHA_DIGESTSIZE = 80

    # SHA-512 initial hash values (in big-endian)
    # (each element represents first 32 bits of the fractional parts of the square roots of the first 8 primes 2..19):
    _h = (
        0x6a09e667f3bcc908, 0xbb67ae8584caa73b, 0x3c6ef372fe94f82b, 0xa54ff53a5f1d36f1, 
        0x510e527fade682d1, 0x9b05688c2b3e6c1f, 0x1f83d9abfb41bd6b, 0x5be0cd19137e2179,
    )
    
    # SHA-512 80 round constants
    # (each element represents first 32 bits of the fractional parts of the cube roots of the first 64 primes 2..311):
    _kt = (
        0x428a2f98d728ae22, 0x7137449123ef65cd, 0xb5c0fbcfec4d3b2f, 0xe9b5dba58189dbbc, 0x3956c25bf348b538, 
        0x59f111f1b605d019, 0x923f82a4af194f9b, 0xab1c5ed5da6d8118, 0xd807aa98a3030242, 0x12835b0145706fbe, 
        0x243185be4ee4b28c, 0x550c7dc3d5ffb4e2, 0x72be5d74f27b896f, 0x80deb1fe3b1696b1, 0x9bdc06a725c71235, 
        0xc19bf174cf692694, 0xe49b69c19ef14ad2, 0xefbe4786384f25e3, 0x0fc19dc68b8cd5b5, 0x240ca1cc77ac9c65, 
        0x2de92c6f592b0275, 0x4a7484aa6ea6e483, 0x5cb0a9dcbd41fbd4, 0x76f988da831153b5, 0x983e5152ee66dfab, 
        0xa831c66d2db43210, 0xb00327c898fb213f, 0xbf597fc7beef0ee4, 0xc6e00bf33da88fc2, 0xd5a79147930aa725, 
        0x06ca6351e003826f, 0x142929670a0e6e70, 0x27b70a8546d22ffc, 0x2e1b21385c26c926, 0x4d2c6dfc5ac42aed, 
        0x53380d139d95b3df, 0x650a73548baf63de, 0x766a0abb3c77b2a8, 0x81c2c92e47edaee6, 0x92722c851482353b, 
        0xa2bfe8a14cf10364, 0xa81a664bbc423001, 0xc24b8b70d0f89791, 0xc76c51a30654be30, 0xd192e819d6ef5218, 
        0xd69906245565a910, 0xf40e35855771202a, 0x106aa07032bbd1b8, 0x19a4c116b8d2d0c8, 0x1e376c085141ab53, 
        0x2748774cdf8eeb99, 0x34b0bcb5e19b48a8, 0x391c0cb3c5c95a63, 0x4ed8aa4ae3418acb, 0x5b9cca4f7763e373, 
        0x682e6ff3d6b2b8a3, 0x748f82ee5defb2fc, 0x78a5636f43172f60, 0x84c87814a1f0ab72, 0x8cc702081a6439ec, 
        0x90befffa23631e28, 0xa4506cebde82bde9, 0xbef9a3f7b2c67915, 0xc67178f2e372532b, 0xca273eceea26619c, 
        0xd186b8c721c0c207, 0xeada7dd6cde0eb1e, 0xf57d4f7fee6ed178, 0x06f067aa72176fba, 0x0a637dc5a2c898a6, 
        0x113f9804bef90dae, 0x1b710b35131c471b, 0x28db77f523047d84, 0x32caab7b40c72493, 0x3c9ebe0a15c9bebc, 
        0x431d67c49c100d4c, 0x4cc5d4becb3e42b6, 0x597f299cfc657e2a, 0x5fcb6fab3ad6faec, 0x6c44198c4a475817,
    )
    
    # M32 constant:
    M32 = 0xFFFFFFFFFFFFFFFF
    _output_size = 8
    
    def __init__(self, msg = None):
        self._buffer  = b''
        self._counter = 0
        
        if msg is not None:
          self.update(msg)
    
    # Round's functions, using lambda or anonymous function in Python:
    
    ROR64 = staticmethod(lambda x, y: (((x & sha512.M32) >> (y & 63)) | (x << (64 - (y & 63)))) & sha512.M32)
    Ch    = staticmethod(lambda x, y, z: (z ^ (x & (y ^ z))))
    Maj   = staticmethod(lambda x, y, z: (((x | y) & z) | (x & y)))
    
    S = staticmethod(lambda x, n: sha512.ROR64(x, n))
    R = staticmethod(lambda x, n: (x & sha512.M32) >> n)
    
    Sigma0 = staticmethod(lambda x: (sha512.S(x, 28) ^ sha512.S(x, 34) ^ sha512.S(x, 39)))
    Sigma1 = staticmethod(lambda x: (sha512.S(x, 14) ^ sha512.S(x, 18) ^ sha512.S(x, 41)))
    
    Gamma0 = staticmethod(lambda x: (sha512.S(x,  1) ^ sha512.S(x,  8) ^ sha512.R(x, 7)))
    Gamma1 = staticmethod(lambda x: (sha512.S(x, 19) ^ sha512.S(x, 61) ^ sha512.R(x, 6)))
    
    # Second derivative of `ROR64`, `Maj`, `Ch` functions:
    ror = lambda x, n: ((x >> n) | (x << (64 - n))) & sha512.M32
    maj = lambda x, y, z: (x & y) ^ (x & z) ^ (y & z)
    ch  = lambda x, y, z: (x & y) ^ ((~x) & z)
    
    # Process the message in successive 512-bit chunks:
    def compress(self, chunks):
        # Create a 64-entry message schedule array w[0..63] of 32-bit words.
        w = [0] * self.SHA_DIGESTSIZE
        # Copy chunk into first 16 words w[0..15] of the message schedule array.
        # w[0:16] = [int.from_bytes(chunks[i : i+4], 'big') for i in range(0, len(chunks), 4)]
        w[0:16] = struct.unpack('!16Q', chunks)
        
        # Extend the first 16 words into the remaining 48 words w[16..63] of the message schedule array:
        for i in range(16, self.SHA_DIGESTSIZE):
            s0   = self.Gamma0(w[i-15])
            s1   = self.Gamma1(w[i-2])
            # s0   = self.ror(w[i - 15],  1) ^ self.ror(w[i - 15],  8) ^ (w[i - 15] >> 7)
            # s1   = self.ror(w[i -  2], 19) ^ self.ror(w[i -  2], 61) ^ (w[i -  2] >> 6)
            w[i] = (w[i-16] + s0 + w[i-7] + s1) & self.M32
            
        # Initialize 8-segments variables to current hash value:
        a, b, c, d, e, f, g, h = self._h
        
        # Compression function main loop:
        for i in range(self.SHA_DIGESTSIZE):
            s0 = self.Sigma0(a)
            # s0 = self.ror(a, 28) ^ self.ror(a, 34) ^ self.ror(a, 39)
            t2 = s0 + self.Maj(a, b, c)
            s1 = self.Sigma1(e)
            # s1 = self.ror(e, 14) ^ self.ror(e, 18) ^ self.ror(e, 41)
            t1 = h + s1 + self.Ch(e, f, g) + self._kt[i] + w[i]
            
            h = g
            g = f
            f = e
            e = (d + t1) & self.M32
            d = c
            c = b
            b = a
            a = (t1 + t2) & self.M32
            
        self._h = [(x+y) & self.M32 for x, y in zip(self._h, [a, b, c, d, e, f, g, h])]
        
    ### UNUSED
    @staticmethod
    def append_pad(msg_len):
        length = (msg_len << 3).to_bytes(8, 'big')
        mdi = msg_len & 0x7F # 0x7F = 627 (in decimal), mdi: message digest initialization.
        pad_len = 111 - mdi if mdi < 112 else 239 - mdi
        
        return b'\x80' + b'\x00' * (pad_len + 8) + length
    ### UNUSED
            
    def update(self, msg):
        if msg is None or len(msg) == 0:
            return
        
        self._buffer  += msg
        self._counter += len(msg)
        
        while len(self._buffer) >= 128:
          self.compress(self._buffer[:128])
          self._buffer = self._buffer[128:]
        
        ### UNUSED
        # `//` operator have contrast semantic compare with `%`
        # for i in range(0, len(msg) // 64):
        #     self.compress(msg[64 * i : 64 * (i+1)])
        # self.buf = msg[len(msg) - (len(msg) % 64) : ]
        ### UNUSED
        
    def digest(self):
        mdi = self._counter & 0x7F
        length = struct.pack('!Q', self._counter << 3)
        pad_len = 111 - mdi if mdi < 112 else 239 - mdi
        
        r = self.copy()
        # FIXME: can not concatenate bytes to string.
        r.update(b'\x80' + (b'\x00' * (pad_len + 8)) + length)
        
        return b''.join([struct.pack('!Q', i) for i in r._h[:self._output_size]])
      
        ### UNUSED
        # if not self.end:
        #     self.update(self.append_pad(self.msg_len))
        #     self.digest = b''.join(h.to_bytes(4, 'big') for h in self.hi[:8])
        #     self.end    = True
        # return self.digest
        ### UNUSED
    
    def hexdigest(self):
        ### UNUSED
        # ele = '0123456789abcdef'
        # return ''.join(ele[byte >> 4] + ele[byte & 0xF] for byte in self.digest())
        ### UNUSED
        
        return self.digest().hex()
      
    def copy(self):
        return copy.deepcopy(self)

def test_rand():
    import secrets, hashlib, random
    
    # Expect value generate by hashlib library:
    for _ in range(500):
        data = secrets.token_bytes(random.randrange(257))
        a, b = hashlib.sha512(data).hexdigest(), sha512(data).hexdigest()
        assert a == b, (a, b)
        
    # Actual value generate by our custom implementation SHA-512 algorithm:
    for _ in range(500):
        a, b = hashlib.sha512(), sha512()
        for _ in range(random.randrange(10)):
            data = secrets.token_bytes(random.randrange(129))
            a.update(data)
            b.update(data)
        a, b = a.hexdigest(), b.hexdigest()
        assert a == b, (a, b)
        
    print('Sha512 tested successfully with random cases.')
    
def test_const():
    import hashlib
    
    data = "Some message needed to be encrypted!".encode('utf-8')
    a, b = hashlib.sha512(data).hexdigest(), sha512(data).hexdigest()
    assert a == b, (a, b)
    print('Sha512 tested successfully with constant string.')
  
if __name__ == '__main__':
    test_rand()
    test_const()
