#ifndef GD_CURV_H
#define GD_CURV_H

#include <mpi.h>

#include "constants.h"
#include "mympi_t.h"

#define GD_TILE_NX 4
#define GD_TILE_NY 4
#define GD_TILE_NZ 4

/*************************************************
 * structure
 *************************************************/
//  grid coordinate for both cart, vmap and curv
//    to reduce duplicated functions
typedef struct {

  int ni, nj, nk;
  int nx, ny, nz;
  int ni1, ni2;
  int nj1, nj2;
  int nk1, nk2;

  int total_point_x;
  int total_point_y;
  int total_point_z;

  int npoint_ghosts;
  int fdx_nghosts;
  int fdy_nghosts;
  int fdz_nghosts;

  // global index
  int gni1, gnj1, gnk1; // global index, do not accout ghost point
  int gni2, gnj2, gnk2; // global index
  // new naming
  int ni1_to_glob_phys0;
  int nj1_to_glob_phys0;
  int nk1_to_glob_phys0;
  int ni2_to_glob_phys0;
  int nj2_to_glob_phys0;
  int nk2_to_glob_phys0;

  // size of a single var
  size_t siz_iy;
  size_t siz_iz;
  size_t siz_icmp;

  // curvilinear coord name,
  char **index_name;
  
  int ncmp;
  float *v4d; // allocated var

  //to avoid ref x3d at different funcs
  float *x3d; // pointer to var
  float *y3d;
  float *z3d;

  // for cart grid
  float *x1d;
  float *y1d;
  float *z1d;
  float dx;
  float dy;
  float dz;
  // x0/y0/z0 for grid gen
  float x0_glob;
  float y0_glob;
  float z0_glob;

  // min/max of this thread including ghost points
  float xmin, xmax;
  float ymin, ymax;
  float zmin, zmax;

  // min/max of this thread for points in physical region
  float xmin_phy, xmax_phy;
  float ymin_phy, ymax_phy;
  float zmin_phy, zmax_phy;

  // boundary of each cell for AABB algorithm
  float *cell_xmin;
  float *cell_xmax;
  float *cell_ymin;
  float *cell_ymax;
  float *cell_zmin;
  float *cell_zmax;
  // boundary of tiles by 4x4x4 partition for AABB algorithm
  int   *tile_istart;
  int   *tile_iend  ;
  int   *tile_jstart;
  int   *tile_jend  ;
  int   *tile_kstart;
  int   *tile_kend  ;
  float *tile_xmin;
  float *tile_xmax;
  float *tile_ymin;
  float *tile_ymax;
  float *tile_zmin;
  float *tile_zmax;

  size_t *cmp_pos;
  char  **cmp_name;
} gd_t;

//  for metric
typedef struct {
  int nx, ny, nz, ncmp;
  float *v4d; // allocated var

  float *jac; // pointer to var
  float *xi_x;
  float *xi_y;
  float *xi_z;
  float *eta_x;
  float *eta_y;
  float *eta_z;
  float *zeta_x;
  float *zeta_y;
  float *zeta_z;

  size_t siz_iy;
  size_t siz_iz;
  size_t siz_icmp;

  size_t *cmp_pos;
  char  **cmp_name;
} gd_metric_t;

/*************************************************
 * function prototype
 *************************************************/

int 
gd_curv_init(gd_t *gd);

int 
gd_curv_metric_init(gd_t        *gd,
                    gd_metric_t *metric);
int
gd_curv_metric_cal(gd_t        *gd,
                   gd_metric_t *metric,
                   int fd_len, int *fd_indx, float *fd_coef);

int 
mirror_symmetry(gd_t *gd, float *v4d, int ncmp);

int 
geometric_symmetry(gd_t *gd, float *v4d, int ncmp);

int
gd_exchange(gd_t *gd,
            float *g3d,
            int ncmp,
            int *neighid,
            MPI_Comm topocomm);

int
gd_curv_gen_cart(gd_t *gd,
                 float dx, float x0,
                 float dy, float y0,
                 float dz, float z0);

int
gd_curv_metric_import(gd_t *gd, gd_metric_t *metric, char *fname_coords, char *import_dir);

int
gd_curv_coord_export(gd_t *gd,
                     char *fname_coords,
                     char *output_dir);

int
gd_curv_coord_import(gd_t *gd,
                     char *fname_coords,
                     char *import_dir);

int
gd_curv_metric_export(gd_t            *gd,
                      gd_metric_t *metric,
                      char *fname_coords,
                      char *output_dir);

int
gd_curv_set_minmax(gd_t *gd);

int
gd_curv_coord_to_glob_indx(gd_t *gd,
                           float sx,
                           float sy,
                           float sz,
                           MPI_Comm comm,
                           int myid,
                           int   *ou_si, int *ou_sj, int *ou_sk,
                           float *ou_sx_inc, float *ou_sy_inc, float *ou_sz_inc);

  int
gd_curv_coord2index_rdinterp(float sx, float sy, float sz, 
                             int num_points,
                             float *points_x, // x coord of all points
                             float *points_y,
                             float *points_z,
                             float *points_i, // curv coord of all points
                             float *points_j,
                             float *points_k,
                             float *si_curv, // interped curv coord
                             float *sj_curv,
                             float *sk_curv);

float
gd_coord_get_x(gd_t *gd, int i, int j, int k);

float
gd_coord_get_y(gd_t *gd, int i, int j, int k);

float
gd_coord_get_z(gd_t *gd, int i, int j, int k);

int
gd_print(gd_t *gd);

__host__ __device__
int
gd_curv_coord_to_local_indx(gd_t *gd,
                            float sx, float sy, float sz,
                            int *si, int *sj, int *sk,
                            float *sx_inc, float *sy_inc, float *sz_inc);

__host__ __device__
int gd_curv_depth_to_axis(gd_t  *gd,
                          float sx,
                          float sy,
                          float *sz,
                          MPI_Comm comm,
                          int myid);

__host__ __device__
int gd_curv_coord2shift_sample(float sx, float sy, float sz, 
                               int num_points,
                               float *points_x, 
                               float *points_y,
                               float *points_z,
                               int    nx_sample,
                               int    ny_sample,
                               int    nz_sample,
                               float *si_shift, 
                               float *sj_shift,
                               float *sk_shift);

__host__ __device__
int gd_curv_coord2index_sample(float sx, float sy, float sz, 
                int num_points,
                float *points_x, // x coord of all points
                float *points_y,
                float *points_z,
                float *points_i, // curv coord of all points
                float *points_j,
                float *points_k,
                int    nx_sample,
                int    ny_sample,
                int    nz_sample,
                float *si_curv, // interped curv coord
                float *sj_curv,
                float *sk_curv);

__host__ __device__
int isPointInHexahedron_c(float px,  float py,  float pz,
                        float *vx, float *vy, float *vz);

__host__ __device__
int point2face(float *hexa1d,float *point, float *p2f);

__host__ __device__
int face_normal(float (*hexa2d)[3], float *normal_unit);

__device__ int
gd_curv_coord_to_glob_indx_gpu(gd_t *gd,
                               float sx,
                               float sy,
                               float sz,
                               MPI_Comm comm,
                               int myid,
                               int *ou_si, int *ou_sj, int *ou_sk,
                               float *ou_sx_inc, float *ou_sy_inc, float *ou_sz_inc);

int
gd_info_set(gd_t *gd,
            mympi_t *mympi,
            int number_of_total_grid_points_x,
            int number_of_total_grid_points_y,
            int number_of_total_grid_points_z,
            int abs_num_of_layers[][2],
            int fdx_nghosts,
            int fdy_nghosts,
            int fdz_nghosts);

int
gd_info_lindx_is_inner(int i, int j, int k, gd_t *gd);

int
gd_info_gindx_is_inner(int gi, int gj, int gk, gd_t *gd);

int
gd_info_gindx_is_inner_i(int gi, gd_t *gd);

int
gd_info_gindx_is_inner_j(int gj, gd_t *gd);

int
gd_info_gindx_is_inner_k(int gk, gd_t *gd);

int
gd_info_indx_glphy2lcext_i(int gi, gd_t *gd);

int
gd_info_indx_glphy2lcext_j(int gj, gd_t *gd);

int
gd_info_indx_glphy2lcext_k(int gk, gd_t *gd);

__host__ __device__
int
gd_info_indx_lcext2glphy_i(int i, gd_t *gd);

__host__ __device__
int
gd_info_indx_lcext2glphy_j(int j, gd_t *gd);

__host__ __device__
int
gd_info_indx_lcext2glphy_k(int k, gd_t *gd);

int
gd_info_print(gd_t *gd);

#endif
