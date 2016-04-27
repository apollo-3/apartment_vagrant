use apartments;
db.users.insert({
  password: "31f2385ba9cc65dba7ccb9aa5c5b7600",
  mail: "apollo-3@mail.ru",
  lang: "en",
  creation_date: new ISODate(),  
  verified: true,
  account: 'standard',
  projects: [
          {
            name: "1st",
            owners: ['apollo-3@mail.ru'],
            description: 'something',
            shared: false,
            creation_date: new ISODate(),
            currency: '$',
            rate: '1',        
            flats: []
          }
  ]  
});
db.users.insert({
  password: "275876e34cf609db118f3d84b799a790",
  mail: "dummy@mail.ru",
  lang: "en",  
  creation_date: new ISODate(),
  verified: true,
  account: 'standard',  
  projects: []
});
db.projects.insert(
                {
                  name: 'shared1',
                  owners: ['apollo-3@mail.ru', 'dostojna9@mail.ru'],
                  description: 'something2',
                  shared: true,
                  creation_date: new ISODate(),
                  currency: '$', 
                  rate: '1',
                  flats: []
                }
)
