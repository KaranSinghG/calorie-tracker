const BASE_URL = 'http://localhost:8080';

export async function login(email: string, password: string): Promise<string> {
    const response = await fetch(`${BASE_URL}/auth/login`, {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json'
        },
        body: JSON.stringify({ email, password })
    });
    if (!response.ok) {
        throw new Error('Invalid email or password');
    }
    const data = await response.json() as { token: string };
    return data.token;
}