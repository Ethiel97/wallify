// module.exports = {
//     routes: [
//       {
//         method: "DELETE",
//         path: "/saved-wallpapers/remove/:uid",
//         handler: "saved-wallpaper.deleteByUid"
//       },
//       {
//         method: "GET",
//         path: "/saved-wallpapers/find/:uid",
//         handler: "saved-wallpaper.findByUid"
//       }
//     ]
//   }


//   'use strict';

// /**
//  *  saved-wallpaper controller
//  */

// const {createCoreController} = require('@strapi/strapi').factories;

// module.exports = createCoreController('api::saved-wallpaper.saved-wallpaper', ({strapi}) => ({

//   create: async (ctx, next) => {
//     const {id} = ctx.state.user;

//     const data = {
//       ...ctx.request.body,
//       userId: id,
//     };

//     const wallpaper = await strapi.db.query('api::saved-wallpaper.saved-wallpaper').findOne({
//       where: {
//         uid: ctx.request.body.uid,
//       }
//     });

//     const entry = await strapi.db.query('api::saved-wallpaper.saved-wallpaper').create({
//       data,
//     });

//     // const sanitizedEntity = await this.sanitizeOutput(entity, ctx);
//     return {data: entry}
//   },

//   findByUid: async (ctx, next) => {
//     const {uid} = ctx.request.params

//     const entity = await strapi.db.query('api::saved-wallpaper.saved-wallpaper').findOne({
//       where: {uid}
//     });

//     // const sanitizedEntity = await this.sanitizeOutput(entity, ctx);
//     return {data: entity}
//   },

//   deleteByUid: async (ctx, next) => {
//     const {uid} = ctx.request.params

//     const entity = await strapi.db.query('api::saved-wallpaper.saved-wallpaper').delete({
//       where: {uid}
//     });

//     /*const entity = await strapi.db.query('api::saved-wallpaper.saved-wallpaper').delete({
//       where: {
//         $or: [
//           {
//             uid
//           },
//           {
//             userId: ctx.state.user.id
//           },
//         ],
//       }
//     });*/

//     return {
//       data: entity,
//     }
//   }
// }));


// {
//     "kind": "collectionType",
//     "collectionName": "saved_wallpapers",
//     "info": {
//       "singularName": "saved-wallpaper",
//       "pluralName": "saved-wallpapers",
//       "displayName": "SavedWallpaper",
//       "description": ""
//     },
//     "options": {
//       "draftAndPublish": true
//     },
//     "pluginOptions": {},
//     "attributes": {
//       "uid": {
//         "type": "uid"
//       }
//     }
//   }
  

  
