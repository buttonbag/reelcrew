import db from "#db/client";
import { createUser } from "#db/queries/users";
import { createFilm } from "#db/queries/films";

await db.connect();
await seed();
await db.end();
console.log("🌱 Database seeded.");

async function seed() {
  await createUser("username", "display_name", "email", "password");
  for (let i = 1; i <= 10; i++) { 
    await createFilm(`${i}`, `title ${i}`, 2000, "director name", Math.floor(Math.random() * 200), "description", "poster_url", "genre", 5);
  }
}
